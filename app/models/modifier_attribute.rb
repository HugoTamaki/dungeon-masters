class ModifierAttribute < ActiveRecord::Base
  attr_accessible :attr, :chapter_id, :quantity

  belongs_to :chapter

  validates :attr, presence: true
  validates :quantity, presence: true, numericality: true
end
