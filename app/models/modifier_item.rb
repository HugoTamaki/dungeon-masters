# == Schema Information
#
# Table name: modifiers_items
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  item_id    :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ModifierItem < ActiveRecord::Base

  belongs_to :chapter, touch: true
  belongs_to :item, touch: true

  validates :quantity, presence: true, numericality: true
end
