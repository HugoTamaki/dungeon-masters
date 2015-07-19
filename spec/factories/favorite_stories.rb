# == Schema Information
#
# Table name: favorite_stories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :favorite_story do
    user_id 1
    story_id 1
  end
end