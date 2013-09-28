class Decision < ActiveRecord::Base
  attr_accessible :destiny_num, :chapter_id

  belongs_to :chapter
end
