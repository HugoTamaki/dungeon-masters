#encoding: UTF-8
# == Schema Information
#
# Table name: adventurers
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  user_id    :integer
#  skill      :integer
#  energy     :integer
#  luck       :integer
#  gold       :integer
#  created_at :datetime
#  updated_at :datetime
#  chapter_id :integer
#  story_id   :integer
#

FactoryGirl.define do
  factory :adventurer do
    name "adventurer"
    user_id 1
    skill 1
    energy 1
    luck 1
    gold 1
  end

end
