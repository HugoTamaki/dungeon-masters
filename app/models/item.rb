# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(40)
#  description :text
#  story_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  usable      :boolean          default(FALSE)
#  attr        :string(255)      default("")
#  modifier    :integer          default(0)
#

class Item < ActiveRecord::Base

  belongs_to :story, touch: true
  has_many :adventurers, through: :adventurers_items
  has_many :modifiers_items, dependent: :destroy
  has_many :modifiers_shops, dependent: :destroy
  has_many :decisions, foreign_key: :item_validator

  validates :name, presence: true

  scope :weapons, -> { where(type: 'Weapon') }
  scope :usable_items, -> { where(type: 'UsableItem') }
  scope :key_items, -> { where(type: 'KeyItem') }
  scope :by_story, lambda {|story_id| where(story_id: story_id)}
end
