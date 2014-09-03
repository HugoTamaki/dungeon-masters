#encoding: UTF-8
# == Schema Information
#
# Table name: adventurers_items
#
#  id            :integer          not null, primary key
#  adventurer_id :integer
#  item_id       :integer
#  status        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  quantity      :integer          default(0)
#

FactoryGirl.define do
  factory :adventurer_item do
    adventurer_id 1
    item_id 1
    status 1
  end

end
