class ChapterMonster < ActiveRecord::Base
  attr_accessible :chapter_id, :monster_id

  belongs_to :chapter
  belongs_to :monster
end
