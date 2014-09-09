require 'spec_helper'

feature "Story" do
  let(:user) {FactoryGirl.create :user}
  let!(:story) {FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 10)}
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
      select 20, from: "Número de Capítulos"

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
      page.should have_text "Title não deve estar em branco"
      page.should have_text "Resume não deve estar em branco"
      page.should have_text "Chapter numbers não deve estar em branco"
      page.should have_text "Chapter numbers não é um número"
    end
  end

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
    let!(:story_sample) {FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 0)}
    let!(:item1) { FactoryGirl.create(:item, name: "espada", description: "uma espada", story: story_sample, usable: false) }
    let!(:item2) { FactoryGirl.create(:item, name: "escudo", description: "um escudo", story: story_sample, usable: false) }
    let!(:item3) { FactoryGirl.create(:item, name: "Pastel", description: "um pastelzinho", story: story_sample, usable: true, attr: "energy", modifier: 4) }
    let!(:item4) { FactoryGirl.create(:item, name: "health drink", description: "bebida revigorante", story: story_sample, usable: true, attr: "energy", modifier: 4) }

    let!(:chapter1) { FactoryGirl.create(:chapter, reference: "1", content: "content 1", story: story_sample) }
    let!(:decision12) { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: 2) }
    let!(:decision13) { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: 3) }
    let!(:decision18) { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: 8, item_validator: item3.id) }
    let!(:modifier_item1) { FactoryGirl.create(:modifier_item, chapter: chapter1, item: item3, quantity: 1) }
    let!(:modifier_item2) { FactoryGirl.create(:modifier_item, chapter: chapter1, item: item4, quantity: 2) }

    let!(:chapter2) { FactoryGirl.create(:chapter, reference: "2", content: "content 2", story: story_sample) }
    let!(:decision25) { FactoryGirl.create(:decision, chapter: chapter2, destiny_num: 5) }
    let!(:monster) { FactoryGirl.create(:monster, chapter: chapter2, name: "goblin", skill: 1, energy: 1) }

    let!(:chapter3) { FactoryGirl.create(:chapter, reference: "3", content: "content 3", story: story_sample) }
    let!(:modifier_item) { FactoryGirl.create(:modifier_item, chapter: chapter3, item: item, quantity: 1) }

    let!(:chapter4) { FactoryGirl.create(:chapter, reference: "4", content: "content 4", story: story_sample) }

    let!(:chapter5) { FactoryGirl.create(:chapter, reference: "5", content: "content 5", story: story_sample) }
    let!(:decision56) { FactoryGirl.create(:decision, chapter: chapter5, destiny_num: 6) }
    let!(:decision57) { FactoryGirl.create(:decision, chapter: chapter5, destiny_num: 7, item_validator: item1.id) }

    let!(:chapter6) { FactoryGirl.create(:chapter, reference: "6", content: "content 6", story: story_sample) }
    let!(:chapter7) { FactoryGirl.create(:chapter, reference: "7", content: "content 7", story: story_sample) }

    let!(:chapter8) { FactoryGirl.create(:chapter, reference: "8", content: "content 8", story: story_sample) }


    before(:each) do
      login_as user
    end

    scenario "user passes through chapters", js: true do
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

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
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 2"

      page.should have_button 'Combate'

      click_button "Combate"
      page.should have_text("goblin morreu!")
    end

    scenario "user receives an item", js: true do
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 3"
      page.should have_text("espada")
    end

    scenario "user does not has an item", js: true do
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

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
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      page.should have_text("content 1")
      
      click_link "Capítulo 8"
      page.should have_text("content 8")

      sleep(0.2)
      page.body.should include("<strike>Pastel</strike>")
    end

    scenario "user uses an usable item and it depletes", js: true do
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

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

    scenario "user uses an usable item and it does not deplete", js: true do
      visit "/stories/#{story_sample.id}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      energy = Adventurer.last.energy

      page.should have_text("content 1")
      
      click_link "Capítulo 2"
      page.should have_text("content 2")

      click_link "health drink"

      Adventurer.last.energy.should be_equal(energy + 4)

      sleep(0.5)
      page.body.should have_text "health drink - 1"
    end
  end

  feature "#publish/unpublish story" do
    before(:each) do
      login_as user
    end

    context "publish a story" do
      let!(:unpublished_story) { FactoryGirl.create(:story, title: 'Unpublished Story', published: false, user: user, chapter_numbers: 0) }

      scenario "user publish a story", js: true do
        visit root_path
        page.should_not have_text "Unpublished Story"

        visit "/stories/#{unpublished_story.id}/edit"

        first(:link, "Publicar").click
        page.should have_text "Publicado com sucesso."

        visit root_path
        page.should have_text "Unpublished Story"
      end
    end

    context "user unpublish a story" do
      let!(:published_story) { FactoryGirl.create(:story, title: 'Published Story', published: true, user: user, chapter_numbers: 0) }

      scenario "user unpublish a story", js: true do
        visit root_path
        page.should have_text "Published Story"

        visit "/stories/#{published_story.id}/edit"

        first(:link, "Despublicar").click
        page.should have_text "Despublicado com sucesso."

        visit root_path
        page.should_not have_text "Published Story"
      end      
    end
  end

  feature "#search story" do
    let!(:story_sample) { FactoryGirl.create(:story, title: "Story sample", published: true, user: user, chapter_numbers: 0) }
    
    before(:each) do
      login_as user
    end

    scenario "user search a story" do
      visit root_path

      page.find('.navbar-search').set 'Story sample'
      click_button "Buscar"
      page.should have_text "Story sample"
      current_path.should == "/stories/search_result"
    end
  end

  feature "add chapters" do
    let!(:story_sample2) { FactoryGirl.create(:story, title: "Story sample", published: true, user: user, chapter_numbers: 10) }
    let!(:chapter1) { FactoryGirl.create(:chapter, reference: "1", content: "content 1", story: story_sample2) }
    let!(:chapter2) { FactoryGirl.create(:chapter, reference: "2", content: "content 2", story: story_sample2) }
    let!(:chapter3) { FactoryGirl.create(:chapter, reference: "3", content: "content 3", story: story_sample2) }
    let!(:chapter4) { FactoryGirl.create(:chapter, reference: "4", content: "content 4", story: story_sample2) }
    let!(:chapter5) { FactoryGirl.create(:chapter, reference: "5", content: "content 5", story: story_sample2) }

    before(:each) do
      login_as user
    end

    scenario "user adds 5 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "+5 capítulos").click
      story_sample2.chapters.count.should == 10
    end

    scenario "user adds 10 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:button, "+10 capítulos").click
      story_sample2.chapters.count.should == 15
    end

    scenario "user adds 20 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:button, "+20 capítulos").click
      story_sample2.chapters.count.should == 25
    end

    scenario "user adds 50 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:button, "+50 capítulos").click
      story_sample2.chapters.count.should == 55
    end
  end

  feature "remove chapters" do
    let!(:story_sample3) { FactoryGirl.create(:story, title: "Story sample", published: true, user: user, chapter_numbers: 50) }

    before(:each) do
      for i in (1..50)
        story_sample3.chapters.build(reference: "#{i}", content: "content #{i}")
      end
      story_sample3.save
      login_as user
    end

    scenario "user removes 5 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:button, "-5 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      story_sample3.chapters.count.should == 45
    end

    scenario "user removes 10 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:button, "-10 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      story_sample3.chapters.count.should == 40
    end

    scenario "user removes 20 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:button, "-20 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      story_sample3.chapters.count.should == 30
    end

    scenario "user removes 50 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:button, "-50 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      story_sample3.chapters.count.should == 0
    end
  end
end