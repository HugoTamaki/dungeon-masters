require 'spec_helper'

feature "Story" do
  let(:user) {FactoryGirl.create :user}
  let!(:story) {FactoryGirl.create(:story, user_id: user.id)}
  let!(:item) {FactoryGirl.create(:item, story_id: story.id)}
  let!(:adventurer) {FactoryGirl.create(:adventurer, user_id: user.id, skill: 5, energy: 5, luck: 5)}

  feature "#create Story" do
    before(:each) do
      login_as user
    end

    scenario "user creates story successfully" do
      visit "/stories/new"

      fill_in "Título", with: "Titulo"
      fill_in "Resumo", with: "Resumo"
      fill_in "Prelúdio", with: "Preludio"
      fill_in "Número de capítulos", with: 5

      click_button "Próximo"

      page.should have_text("História foi criada com sucesso.")
      current_path.should == "/stories/#{Story.last.id}/edit" 
    end

    scenario "user fails to create story" do
      visit "/stories/new"

      fill_in "Título", with: ""
      fill_in "Resumo", with: ""
      fill_in "Prelúdio", with: ""

      click_button "Próximo"

      current_path.should == "/stories/new"
      page.should have_text("alguns dados estão faltando")
    end
  end

  feature "#create chapters" do

    before(:each) do
      login_as user
    end

    scenario "user creates story successfully", js: true do
      visit "/stories/#{story.id}/edit"

      click_link "Adicionar Capítulo"
      fill_in "Referencia", with: "Referencia"
      fill_in "Conteúdo", with: "Conteudo"
      click_link "Adicionar Destino"
      fill_in "Destino", with: 5
      click_link "Adicionar Monstro"
      fill_in "Nome", with: "monster"
      fill_in "Habilidade", with: 5
      fill_in "Energia", with: 5
      click_link "Adicionar Item"
      select "espada", from: "Item"
      fill_in "Quantidade", with: 1

      first(:button, "Terminar Edição").click
      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("História atualizada com sucesso.")
    end

    scenario "user creates story without success", js: true do
      visit "/stories/#{story.id}/edit"

      click_link "Adicionar Capítulo"
      fill_in "Referencia", with: ""
      fill_in "Conteúdo", with: ""
      click_link "Adicionar Monstro"
      fill_in "Nome", with: "monster"

      first(:button, "Terminar Edição").click
      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("Chapters monsters skill não deve estar em branco")
      page.should have_text("Chapters monsters skill não é um número")
      page.should have_text("Chapters monsters energy não deve estar em branco")
      page.should have_text("Chapters monsters energy não é um número")
    end
  end

  feature "#create items" do
    before(:each) do
      login_as user
    end

    scenario "user creates item successfully" do
      visit "stories/#{story.id}/edit_items"

      fill_in "Nome", with: "Escudo"
      fill_in "Descrição", with: "um escudo"

      click_button "Editar Capítulos"

      current_path.should == "/stories/#{Story.last.id}/edit"
      page.should have_text("Dados salvos.")
      Item.last.name.should == "Escudo"
      Item.last.description.should == "um escudo"
    end

    scenario "user fails to create item" do
      visit "stories/#{story.id}/edit_items"

      fill_in "Nome", with: ""
      fill_in "Descrição", with: "um escudo"

      click_button "Editar Capítulos"

      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("Items name não deve estar em branco")
      Item.last.name.should_not == "Escudo"
      Item.last.description.should_not == "um escudo"
    end
  end

  feature "#delete story", js: true do

    before(:each) do
      login_as user
    end

    scenario "user deletes a story" do
      visit "/stories"

      page.should have_text("Titulo")
      click_link("Deletar história")
      page.driver.browser.switch_to.alert.accept
      page.should have_text("Nenhuma história")
      current_path.should == "/stories"
    end
  end

  feature "#read story" do
    let(:story_sample) {FactoryGirl.create(:story, user_id: user.id)}

    before(:each) do
      for i in (1..8)
        story_sample.chapters.build(reference: "#{i}", content: "content #{i}")
      end
      story_sample.items.build(name: "espada", description: "uma espada")
      story_sample.items.build(name: "escudo", description: "um escudo")
      story_sample.items.build(name: "Pastel", description: "Um pastelzinho", usable: true, modifier: 4, attr: "energy")
      story_sample.save
      items = story.items

      story_sample.chapters[0].decisions.build(destiny_num: 2)
      story_sample.chapters[0].decisions.build(destiny_num: 3)
      story_sample.chapters[0].decisions.build(destiny_num: 8, item_validator: Item.last.id)
      story_sample.chapters[0].modifiers_items.build(item_id: Item.last.id, quantity: 1)
      story_sample.chapters[2].modifiers_items.build(item_id: items.last.id, quantity: 1)
      story_sample.chapters[1].decisions.build(destiny_num: 5)
      story_sample.chapters[4].decisions.build(destiny_num: 6)
      story_sample.chapters[4].decisions.build(destiny_num: 7, item_validator: items.last.id)
      story_sample.chapters[1].monsters.build(name: "goblin",skill: 1, energy: 1)
      story_sample.save
      login_as user
    end

    scenario "user passes through chapters", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      page.should have_text("content 1")
      
      click_link "Capítulo 2"
      page.should have_text("content 2")

      page.should have_button 'Combat'
      click_button "Combate"

      click_link "Capítulo 5"
      page.should have_text("content 5")
    end

    scenario "user does combat", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 2"

      page.should have_button 'Combate'

      click_button "Combate"
      page.should have_text("goblin morreu!")
    end

    scenario "user receives an item", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 3"
      page.should have_text("espada")
    end

    scenario "user does not has an item", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      page.should have_text("content 1")
      
      click_link "Capítulo 2"
      page.should have_text("content 2")

      page.should have_button 'Combat'
      click_button "Combate"

      click_link "Capítulo 5"
      page.should have_text("content 5")
      page.should have_css ".disabled"
    end

    scenario "user has an item and passes trough", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      page.should have_text("content 1")
      
      click_link "Capítulo 8"
      page.should have_text("content 8")

      sleep(0.2)
      page.body.should include("<strike>Pastel</strike>")
    end

    scenario "user uses an usable item", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      energy = Adventurer.last.energy

      page.should have_text("content 1")
      
      click_link "Capítulo 2"
      page.should have_text("content 2")

      click_link "Pastel"

      Adventurer.last.energy.should be_equal(energy + 4)

      sleep(0.5)
      page.body.should include("<strike>pastel</strike>")
    end
  end
end