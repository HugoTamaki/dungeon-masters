class ModifierAttribute < ActiveRecord::Base

  belongs_to :chapter

  validates :attr, presence: true
  validates :quantity, presence: true, numericality: true
end
