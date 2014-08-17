#encoding: UTF-8
# == Schema Information
#
# Table name: modifiers_attributes
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  attr       :string(255)
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#


FactoryGirl.define do
  factory :modifier_attribute do
    attr "algum atributo"
    chapter_id 1
    quantity 1
  end

end
