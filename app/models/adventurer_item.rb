class AdventurerItem < ActiveRecord::Base

  belongs_to :adventurer
  belongs_to :item

  before_create do
    self.status = 1
  end

  scope :by_adventurer, lambda {|adventurer_id| where(adventurer_id: adventurer_id)}
end
