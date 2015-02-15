# == Schema Information
#
# Table name: adventurers_shops
#
#  id               :integer          not null, primary key
#  adventurer_id    :integer
#  modifier_shop_id :integer
#  quantity         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class AdventurerShop < ActiveRecord::Base
  belongs_to :adventurer
  belongs_to :modifier_item
end
