#encoding: UTF-8

FactoryGirl.define do
  factory :user do
    email "email@email.com"
    password "11111111"
    password_confirmation "11111111"
  end
end