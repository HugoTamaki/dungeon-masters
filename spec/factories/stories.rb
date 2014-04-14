#encoding: UTF-8

FactoryGirl.define do
  factory :story do
    title "Titulo"
    resume "Resumo"
    prelude "Preludio"
    user_id 1
#    cover { File.new("#{Rails.root}/spec/photos/test.png") }
  end

end