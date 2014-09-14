require 'spec_helper'

feature Chapter do
  let(:user) {FactoryGirl.create :user}
  let!(:story) {FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 10)}
  let!(:item) {FactoryGirl.create(:item, story_id: story.id)}
  let!(:adventurer) {FactoryGirl.create(:adventurer, user_id: user.id, skill: 5, energy: 5, luck: 5)}

  feature "#create chapters" do
    let!(:chapter1) { FactoryGirl.create(:chapter, reference: "1", story_id: story.id) }
    let!(:chapter2) { FactoryGirl.create(:chapter, reference: "2", story_id: story.id) }
    let!(:chapter3) { FactoryGirl.create(:chapter, reference: "3", story_id: story.id) }
    let!(:chapter4) { FactoryGirl.create(:chapter, reference: "4", story_id: story.id) }
    let!(:chapter5) { FactoryGirl.create(:chapter, reference: "5", story_id: story.id) }

    before(:each) do
      login_as user
    end

    scenario "user creates story successfully", js: true do
      visit "/stories/#{story.id}/edit"
      all(".ui-accordion-header")[0].click

      click_link "Adicionar Destino"
      select "5", from: "Decisões"
      click_link "Adicionar Monstro"
      fill_in "Nome", with: "monster"
      select "5", from: "Habilidade"
      select "5", from: "Energia"
      click_link "Adicionar Item"
      select "espada", from: "Item"
      select "1", from: "Quantidade"

      first(:button, "Terminar Edição").click
      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("História atualizada com sucesso.")
    end

    scenario "user creates story without success", js: true do
      visit "/stories/#{story.id}/edit"
      all(".ui-accordion-header")[0].click

      click_link "Adicionar Monstro"
      fill_in "Nome", with: "monster"

      first(:button, "Terminar Edição").click
      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text "Chapters monsters skill não deve estar em branco"
      page.should have_text "Chapters monsters skill não é um número"
      page.should have_text "Chapters monsters energy não deve estar em branco"
      page.should have_text "Chapters monsters energy não é um número"
      page.should have_text "Capítulos com erros: 1"
    end
  end
end
