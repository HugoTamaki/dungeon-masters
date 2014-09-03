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

class AdventurerChapter < ActiveRecord::Base
  belongs_to :adventurer
  belongs_to :chapter
end
