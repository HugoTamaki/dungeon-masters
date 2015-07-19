# == Schema Information
#
# Table name: adventurer_chapters
#
#  id            :integer          not null, primary key
#  adventurer_id :integer
#  chapter_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :adventurer_chapter do
    adventurer_id 1
    chapter_id 1
  end
end