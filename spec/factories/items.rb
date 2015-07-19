#encoding: UTF-8
# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(40)
#  description :text
#  story_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  usable      :boolean          default(FALSE)
#  attr        :string(255)      default("")
#  modifier    :integer          default(0)
#

FactoryGirl.define do
  factory :item do
    name "espada"
    description "uma espada"
  end

end
