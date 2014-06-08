class ModifierItem < ActiveRecord::Base

  belongs_to :chapter
  belongs_to :item

  validates :quantity, presence: true, numericality: true
end
