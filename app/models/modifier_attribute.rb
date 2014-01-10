class ModifierAttribute < ActiveRecord::Base
  attr_accessible :attribute, :chapter_id, :quantity

  belongs_to :chapter
end
