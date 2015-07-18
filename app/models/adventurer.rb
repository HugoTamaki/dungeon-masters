# == Schema Information
#
# Table name: adventurers
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  user_id    :integer
#  skill      :integer
#  energy     :integer
#  luck       :integer
#  gold       :integer
#  created_at :datetime
#  updated_at :datetime
#  chapter_id :integer
#  story_id   :integer
#

class Adventurer < ActiveRecord::Base

  validates :skill, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :luck, presence: true, numericality: true

  belongs_to :user
  belongs_to :story
  belongs_to :chapter
  has_many :adventurers_items, inverse_of: :adventurer, dependent: :destroy
  has_many :items, through: :adventurers_items
  has_many :adventurers_shops
  has_many :modifiers_items, through: :adventurers_shops
  has_many :adventurer_chapters, inverse_of: :adventurer, dependent: :destroy
  has_many :chapters, through: :adventurer_chapters
  accepts_nested_attributes_for :adventurers_items, reject_if: :all_blank, allow_destroy: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}
  scope :by_user_and_story, lambda {|user, story| where(user_id: user.id, story_id: story.id)}

  def clear
    self.chapters.clear
    self.adventurers_items.clear
    self.adventurers_shops.clear
    self.skill = nil
    self.energy = nil
    self.luck = nil
    self.save(validate: false)
  end

  def attribute_and_item_changer(chapter)
    if chapter.modifiers_attributes.present?
      unless self.chapters.include? chapter
        chapter.modifiers_attributes.each do |attribute|
          change_attribute(attribute.attr, attribute.quantity)
        end
      end
    end

    if chapter.modifiers_items.present?
      chapter.modifiers_items.each do |item|
        unless self.chapters.include? chapter
          if self.dont_have_item(item.item.id)
            self.items << item.item unless self.items.include? item.item
            adventurer_item = self.adventurers_items.find_by(item_id: item.item.id)
            adventurer_item.quantity += item.quantity if adventurer_item.item.usable
            adventurer_item.status = 1 unless adventurer_item.item.usable
            adventurer_item.save
          else
            adventurer_item = self.adventurers_items.find_by(item_id: item.item.id)
            adventurer_item.quantity += item.quantity if adventurer_item.item.usable
            adventurer_item.status = 1 unless adventurer_item.item.usable
            adventurer_item.save
          end
        end
      end
      self.save
    end
  end

  def set_chapter_and_gold(chapter, story, reference)
    self.chapter_id = chapter.id
    self.story = story
    self.gold = story.initial_gold if story.initial_gold > 0 && reference == "1"
    self.save
  end

  def dont_have_item(item_id)
    adventurer_items = self.items.where(id: item_id)
    used_item = AdventurerItem.where(adventurer_id: self.id, item_id: item_id).first
    (adventurer_items.empty? || used_item.status == 0) ? true : false
  end

  def use_required_item(decision)
    unless decision.nil?
      if decision.has_item_validation?
        required_item = decision.item
        if required_item.usable
          self.change_attribute(required_item.attr, required_item.modifier)
        end
        adventurer_item = AdventurerItem.find_by(item_id: required_item.id)
        adventurer_item.status = 0 unless required_item.usable
        adventurer_item.quantity -= 1 if adventurer_item.quantity > 0 && required_item.usable
        adventurer_item.save
      end
    end
  end

  def change_attribute(attribute, modifier)
    case attribute
      when "skill"
        self.skill += modifier.to_i
        self.skill = 12 if self.skill > 12
      when "energy"
        self.energy += modifier.to_i
        self.energy = 24 if self.energy > 24
      when "luck"
        self.luck += modifier.to_i
        self.luck = 12 if self.luck > 12
      when "gold"
        self.gold += modifier.to_i
    end

    self.save
  end

  def self.clear_or_create_adventurer(adventurer, story_id)
    if adventurer.nil?
      adventurer = Adventurer.new
      adventurer.story_id = story_id
    else
      adventurer.clear
    end
    adventurer
  end

  def adventurer_modifier_shop_present? shop_id
    self.adventurers_shops.any? {|adv_shop| adv_shop.modifier_shop_id == shop_id.to_i}
  end

  def cant_buy?(adventurer_modifier_shop, price)
    self.gold ||= 0
    if adventurer_modifier_shop
      self.gold < 1 || adventurer_modifier_shop.quantity < 1 || self.gold < price
    else
      self.gold < 1 || self.gold < price
    end
  end

  def buy_same_item item, price
    adventurer_item = self.adventurers_items.where(item_id: item.id).first
    adventurer_item.quantity += 1
    adventurer_item.save
    self.gold -= price
    self.save
  end

  def buy_new_item item, price
    self.adventurers_items.create(item_id: item.id, quantity: 1)
    self.gold -= price
    self.save
  end
end
