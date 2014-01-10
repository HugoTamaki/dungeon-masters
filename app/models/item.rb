class Item < ActiveRecord::Base
  attr_accessible :description, :name, :story_id

  belongs_to :story
  has_many :adventurers, through: :adventurers_items
  has_many :modifiers_items, dependent: :destroy

  scope :by_story, lambda {|story_id| where(story_id: story_id)}
end
