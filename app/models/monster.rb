class Monster < ActiveRecord::Base
  attr_accessible :skill, :energy, :name, :chapter_id

  belongs_to :chapter
end
