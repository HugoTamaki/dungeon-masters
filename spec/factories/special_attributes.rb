#encoding: UTF-8
# == Schema Information
#
# Table name: special_attributes
#
#  id            :integer          not null, primary key
#  name          :string(40)
#  adventurer_id :integer
#  story_id      :integer
#  value         :integer
#  created_at    :datetime
#  updated_at    :datetime
#


FactoryGirl.define do
  factory :special_attribute do
    name "attribute"
    adventurer_id 1
    story_id 1
    value 1
  end

end
