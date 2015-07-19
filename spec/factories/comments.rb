# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :comment do
    user_id 1
    story_id 1
    content 'something here'
  end
end