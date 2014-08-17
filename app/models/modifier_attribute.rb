# == Schema Information
#
# Table name: modifiers_attributes
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  attr       :string(255)
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ModifierAttribute < ActiveRecord::Base

  belongs_to :chapter

  validates :attr, presence: true
  validates :quantity, presence: true, numericality: true
end
