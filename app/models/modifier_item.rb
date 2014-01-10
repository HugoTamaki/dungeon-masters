class ModifierItem < ActiveRecord::Base
  attr_accessible :chapter_id, :item_id, :quantity, :items_attributes

  belongs_to :chapter
  belongs_to :item
end
