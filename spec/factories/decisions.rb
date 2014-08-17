#encoding: UTF-8
# == Schema Information
#
# Table name: decisions
#
#  id             :integer          not null, primary key
#  chapter_id     :integer
#  destiny_num    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  item_validator :integer
#


FactoryGirl.define do
  factory :decision do
    destiny_num 1
    chapter_id 1
  end

end
