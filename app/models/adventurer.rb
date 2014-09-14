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
  has_many :adventurer_chapters, inverse_of: :adventurer, dependent: :destroy
  has_many :chapters, through: :adventurer_chapters
  accepts_nested_attributes_for :adventurers_items, reject_if: :all_blank, allow_destroy: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}

  def self.attribute_and_item_changer(adventurer, chapter)
    if chapter.modifiers_attributes.present?
      unless adventurer.chapters.include? chapter
        chapter.modifiers_attributes.each do |attribute|
          change_attribute(adventurer, attribute.attr, attribute.quantity)
        end
      end
    end

    if chapter.modifiers_items.present?
      chapter.modifiers_items.each do |item|
        unless adventurer.chapters.include? chapter
          if dont_have_item(adventurer, item.item.id)
            adventurer.items << item.item unless adventurer.items.include? item.item
            adventurer_item = adventurer.adventurers_items.find_by(item_id: item.item.id)
            adventurer_item.quantity += item.quantity if adventurer_item.item.usable
            adventurer_item.status = 1 unless adventurer_item.item.usable
            adventurer_item.save
          else
            adventurer_item = adventurer.adventurers_items.find_by(item_id: item.item.id)
            adventurer_item.quantity += item.quantity if adventurer_item.item.usable
            adventurer_item.status = 1 unless adventurer_item.item.usable
            adventurer_item.save
          end
        end
      end
      adventurer.save
    end
    adventurer
  end

  def self.dont_have_item(adventurer,item_id)
    adventurer_items = adventurer.items.where(id: item_id)
    used_item = AdventurerItem.where(adventurer_id: adventurer.id, item_id: item_id).first
    (adventurer_items.empty? || used_item.status == 0) ? true : false
  end

  def self.use_required_item(decision,adventurer)
    unless decision.nil?
      if decision.item_validator
        required_item = Item.find(decision.item_validator)
        if required_item.usable
          change_attribute(adventurer, required_item.attr, required_item.modifier)
        end
        adventurer_item = AdventurerItem.find_by(item_id: required_item.id)
        adventurer_item.status = 0 unless required_item.usable
        adventurer_item.quantity -= 1 if adventurer_item.quantity > 0 && required_item.usable
        adventurer_item.save
      end
    end
    adventurer
  end

  def self.change_attribute(adventurer, attribute, modifier)
    case attribute
      when "skill"
        adventurer.skill += modifier.to_i
      when "energy"
        adventurer.energy += modifier.to_i
      when "luck"
        adventurer.luck += modifier.to_i
      when "gold"
        adventurer.gold += modifier.to_i
    end

    adventurer.save
  end
end
