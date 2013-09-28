class Item < ActiveRecord::Base
  attr_accessible :description, :name, :story_id

  belongs_to :story
  has_many :adventurers, through: :adventurers_items

end
