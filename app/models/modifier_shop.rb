# == Schema Information
#
# Table name: modifiers_shops
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  item_id    :integer
#  price      :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ModifierShop < ActiveRecord::Base

  belongs_to :chapter, touch: true
  belongs_to :item, touch: true
  has_many :adventurers_shops, dependent: :destroy

  validates :price, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
end
