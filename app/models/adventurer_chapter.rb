class AdventurerChapter < ActiveRecord::Base
  belongs_to :adventurer
  belongs_to :chapter
end
