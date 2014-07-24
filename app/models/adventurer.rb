class Adventurer < ActiveRecord::Base

  validates :skill, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :luck, presence: true, numericality: true

  belongs_to :user
  has_many :adventurers_items, inverse_of: :adventurer, dependent: :destroy
  has_many :items, through: :adventurers_items
  has_many :special_attributes
  accepts_nested_attributes_for :adventurers_items, reject_if: :all_blank, allow_destroy: true

  scope :by_user, lambda {|user_id| where(user_id: user_id)}

  def self.attribute_and_item_changer(adventurer, chapter)
    if chapter.modifiers_attributes.present?
      chapter.modifiers_attributes.each do |attribute|
        change_attribute(adventurer, attribute.attr, attribute.quantity)
      end
    end

    if chapter.modifiers_items.present?
      chapter.modifiers_items.each do |item|
        adventurer.items << item.item if dont_have_item(adventurer,item.item.id)
      end
      adventurer.save
    end
    adventurer
  end

  def self.dont_have_item(adventurer,item_id)
    adventurer_items = adventurer.items.where(id: item_id)
    adventurer_items.empty? ? true : false
  end

  def self.use_required_item(decision,adventurer)
    unless decision.nil?
      if decision.item_validator
        required_item = Item.find(decision.item_validator)
        if required_item.usable
          change_attribute(adventurer, required_item.attr, required_item.modifier)
        end
        adventurer_item = AdventurerItem.find_by(item_id: required_item.id)
        adventurer_item.status = 0
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
