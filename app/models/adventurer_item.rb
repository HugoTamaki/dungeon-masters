class AdventurerItem < ActiveRecord::Base
  attr_accessible :adventurer_id, :item_id, :status

  belongs_to :adventurer
  belongs_to :item
end
