class Monster < ActiveRecord::Base
  attr_accessible :ability, :energy, :name, :story_id

  belongs_to :story
end
