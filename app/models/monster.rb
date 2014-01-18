class Monster < ActiveRecord::Base
  attr_accessible :skill, :energy, :name, :chapter_id

  belongs_to :chapter

  validates :skill, presence: true
  validates :energy, presence: true
  validates :name, presence: true
end
