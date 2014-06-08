class SpecialAttribute < ActiveRecord::Base

  belongs_to :adventurer
  belongs_to :story

  validates :name, presence: true
end
