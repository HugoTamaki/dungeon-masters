# == Schema Information
#
# Table name: special_attributes
#
#  id            :integer          not null, primary key
#  name          :string(40)
#  adventurer_id :integer
#  story_id      :integer
#  value         :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class SpecialAttribute < ActiveRecord::Base

  belongs_to :adventurer
  belongs_to :story

  validates :name, presence: true
end
