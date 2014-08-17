#encoding: UTF-8
# == Schema Information
#
# Table name: monsters
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  skill      :integer
#  energy     :integer
#  chapter_id :integer
#  created_at :datetime
#  updated_at :datetime
#


FactoryGirl.define do
  factory :monster do
    name "monster"
    skill 1
    energy 1
    chapter_id 1
  end

end
