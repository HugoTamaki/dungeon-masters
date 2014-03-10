#encoding: UTF-8

Dado(/^que eu esteja na página de sign in$/) do
  visit new_user_session_path
end

Dado(/^que eu esteja na página inicial$/) do
  visit root_path
end

Dado(/^que eu esteja logado como usuário "([^"]*)" e password "([^"]*)"$/) do |email, pass|
  visit new_user_session_path
  FactoryGirl.create(:user, :email => email, :password => pass)
  fill_in 'Email', :with => email
  fill_in 'Password', :with => pass
  click_button 'Sign in'
end

E(/^eu clique no link "([^"]*)"$/) do |link|
  click_link link
  sleep(1)
end

E(/^eu clico no botão "([^"]*)"/) do |botao|
  first(:button, botao).click
  sleep(1)
end

Então(/^eu devo estar na página de histórias/) do
  current_path.should be_in(stories_path)
end

Então(/^eu devo estar na página de Sign in/) do
  current_path.should be_in(new_user_session_path)
end

Então(/^eu devo estar na página de edição de capítulos$/) do
  story = Story.find(1)
  current_path.should be_in(edit_story_path(story))
end

E(/^eu devo ver a mensagem "([^"]*)"$/) do |msg|
  page.should have_content(msg)
end

Então(/^eu devo estar na página de criação de história/) do
  current_path.should be_in(new_story_path)
end

E(/^eu esteja na página de edição de capítulos$/) do
  story = Story.find(1)
  visit edit_story_path(story)
end
