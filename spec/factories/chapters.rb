#encoding: UTF-8
# == Schema Information
#
# Table name: chapters
#
#  id                 :integer          not null, primary key
#  story_id           :integer
#  reference          :string(10)
#  content            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  x                  :float
#  y                  :float
#  color              :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#


FactoryGirl.define do
  factory :chapter do
    content "algum conteudo"
    reference "200"
    story_id 1
    x "0.4"
    y "0.5"
    color "#FFFFFF"
  end

end
