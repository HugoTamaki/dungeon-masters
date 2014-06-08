class Item < ActiveRecord::Base

  belongs_to :story
  has_many :adventurers, through: :adventurers_items
  has_many :modifiers_items, dependent: :destroy

  validates :description, presence: true
  validates :name, presence: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}
end
