class Monster < ActiveRecord::Base

  belongs_to :chapter

  validates :skill, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :name, presence: true
end
