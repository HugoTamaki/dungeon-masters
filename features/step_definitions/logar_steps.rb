#encoding: UTF-8

Dado(/^que exista um usuário de email "([^"]*)" e password "([^"]*)"$/) do |email, password|
  FactoryGirl.create(:user, :email => email, :password => password)
end

Dado(/^que não exista um usuário de email "([^"]*)" e password 11111111$/) do |email|
  User.where(:email => email).delete_all
end

Quando(/^eu preencho os campos de email com "([^"]*)" e password "([^"]*)"$/) do |email, password|
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
end