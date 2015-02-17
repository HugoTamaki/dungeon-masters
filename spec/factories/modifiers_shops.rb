#encoding: UTF-8
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

FactoryGirl.define do
  factory :modifier_shop do
    chapter_id 1
    item_id 1
    price 1
    quantity 1
  end
end
