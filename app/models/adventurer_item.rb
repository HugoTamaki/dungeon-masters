# == Schema Information
#
# Table name: adventurers_items
#
#  id            :integer          not null, primary key
#  adventurer_id :integer
#  item_id       :integer
#  status        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  quantity      :integer          default(0)
#

class AdventurerItem < ActiveRecord::Base

  belongs_to :adventurer
  belongs_to :item

  scope :by_adventurer, lambda {|adventurer_id| where(adventurer_id: adventurer_id)}
  scope :selected, -> { where(selected: true) }
end
