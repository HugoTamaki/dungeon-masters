#encoding: UTF-8

Quando(/^eu preencho os campos da história com "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |titulo, resumo, preludio|
  fill_in "Title", :with => titulo
  fill_in "Resume", :with => resumo
  fill_in "Prelude", :with => preludio
end