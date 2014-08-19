# == Schema Information
#
# Table name: monsters
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  skill      :integer
#  energy     :integer
#  chapter_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Monster < ActiveRecord::Base

  belongs_to :chapter, touch: true

  validates :skill, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :name, presence: true
end
