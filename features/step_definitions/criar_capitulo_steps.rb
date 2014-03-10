#encoding: UTF-8

Dado(/^que eu tenha criado uma nova história corretamente com "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |titulo, resumo, preludio|
  click_link "New Story"
  fill_in "Title", :with => titulo
  fill_in "Resume", :with => resumo
  fill_in "Prelude", :with => preludio
  click_button "Next"
end

Quando(/^eu preencho a referência e o conteúdo com "([^"]*)" e "([^"]*)"$/) do |referencia, conteudo|
  click_link "Add chapters"
  fill_in "Reference", :with => referencia
  fill_in "Content", :with => conteudo
end