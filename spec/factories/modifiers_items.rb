#encoding: UTF-8
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


FactoryGirl.define do
  factory :modifier_item do
    chapter_id 1
    item_id 1
    quantity 1
  end

end
