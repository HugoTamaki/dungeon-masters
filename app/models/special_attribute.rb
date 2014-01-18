class SpecialAttribute < ActiveRecord::Base
  attr_accessible :adventurer_id, :name, :value, :story_id

  belongs_to :adventurer
  belongs_to :story

  validates :name, presence: true
end
