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

  def self.attribute_changer(adventurer, chapter)
    if chapter.modifiers_attributes.present?
      chapter.modifiers_attributes.each do |attribute|
        case attribute.attr
        when "skill"
          adventurer.skill = adventurer.skill + attribute.quantity
        when "energy"
          adventurer.energy = adventurer.energy + attribute.quantity
        when "luck"
          adventurer.luck = adventurer.luck + attribute.quantity
        when "gold"
          adventurer.gold = adventurer.gold + attribute.quantity
        end
      end
      adventurer.save
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
end
