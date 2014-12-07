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
#  usable      :boolean
#  attr        :string(255)
#  modifier    :integer
#

class Item < ActiveRecord::Base

  belongs_to :story, touch: true
  has_many :adventurers, through: :adventurers_items
  has_many :modifiers_items, dependent: :destroy

  validates :description, presence: true
  validates :name, presence: true

  before_update do
    unless self.usable
      self.attr = ''
      self.modifier = 0
    end
  end

  scope :by_story, lambda {|story_id| where(story_id: story_id)}
end
