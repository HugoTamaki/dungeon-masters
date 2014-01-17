class ModifierAttribute < ActiveRecord::Base
  attr_accessible :attr, :chapter_id, :quantity

  belongs_to :chapter

  validates :attr, numericality: true
end
