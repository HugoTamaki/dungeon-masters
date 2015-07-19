#encoding: UTF-8
# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  title              :string(40)
#  resume             :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  prelude            :text
#  cover              :string(255)
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  published          :boolean          default(FALSE)
#  chapter_numbers    :integer
#  initial_gold       :integer          default(0)
#

FactoryGirl.define do
  factory :story do
    title "Titulo"
    resume "Resumo"
    prelude "Preludio"
    chapter_numbers 10
#    cover { File.new("#{Rails.root}/spec/photos/test.png") }
  end

end
