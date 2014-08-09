#encoding: UTF-8

FactoryGirl.define do
  factory :chapter do
    content "algum conteudo"
    reference "200"
    story_id 1
    x "1.0"
    y "1.0"
    color "#FFFFFF"
  end

end