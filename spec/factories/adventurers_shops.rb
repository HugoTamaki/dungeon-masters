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

FactoryGirl.define do
  factory :adventurer_shop do
    adventurer_id 1
    modifier_shop_id 1
    quantity 1
  end
end
