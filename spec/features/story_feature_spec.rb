require 'spec_helper'

feature "Story" do
  let(:user)            { FactoryGirl.create :user, name: 'Fulano'}
  let!(:story)          { FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 10)}
  let!(:item)           { FactoryGirl.create(:item, story_id: story.id)}
  let!(:adventurer)     { FactoryGirl.create(:adventurer, user_id: user.id, skill: 5, energy: 5, luck: 5)}
  let!(:story_sample)   { FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 0, initial_gold: 20)}
  let!(:item1)          { FactoryGirl.create(:item, name: "espada", description: "uma espada", story: story_sample, type: 'Weapon') }
  let!(:item2)          { FactoryGirl.create(:item, name: "escudo", description: "um escudo", story: story_sample, type: 'KeyItem') }
  let!(:item3)          { FactoryGirl.create(:item, name: "Pastel", description: "um pastelzinho", story: story_sample, type: 'UsableItem', attr: "energy", modifier: 4) }
  let!(:item4)          { FactoryGirl.create(:item, name: "health drink", description: "bebida revigorante", story: story_sample, type: 'UsableItem', attr: "energy", modifier: 4) }
  let!(:item5)          { FactoryGirl.create(:item, name: "lança", description: "uma lança", story: story_sample, type: 'Weapon') }

  let!(:chapter1)       { FactoryGirl.create(:chapter, reference: "1", content: "content 1", story: story_sample) }
  let!(:chapter2)       { FactoryGirl.create(:chapter, reference: "2", content: "content 2", story: story_sample) }
  let!(:chapter3)       { FactoryGirl.create(:chapter, reference: "3", content: "content 3", story: story_sample) }
  let!(:chapter4)       { FactoryGirl.create(:chapter, reference: "4", content: "content 4", story: story_sample) }
  let!(:chapter5)       { FactoryGirl.create(:chapter, reference: "5", content: "content 5", story: story_sample) }
  let!(:chapter6)       { FactoryGirl.create(:chapter, reference: "6", content: "content 6", story: story_sample) }
  let!(:chapter7)       { FactoryGirl.create(:chapter, reference: "7", content: "content 7", story: story_sample) }
  let!(:chapter8)       { FactoryGirl.create(:chapter, reference: "8", content: "content 8", story: story_sample) }
  let!(:chapter9)       { FactoryGirl.create(:chapter, reference: "9", content: "content 9", story: story_sample) }
  let!(:chapter10)      { FactoryGirl.create(:chapter, reference: "10", content: "content 10", story: story_sample) }
  let!(:chapter11)      { FactoryGirl.create(:chapter, reference: "11", content: "content 11", story: story_sample) }

  let!(:decision12)     { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: chapter2.id) }
  let!(:decision13)     { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: chapter3.id) }
  let!(:decision18)     { FactoryGirl.create(:decision, chapter: chapter1, destiny_num: chapter8.id, item_validator: item3.id) }
  let!(:decision25)     { FactoryGirl.create(:decision, chapter: chapter2, destiny_num: chapter5.id) }
  let!(:decision29)     { FactoryGirl.create(:decision, chapter: chapter2, destiny_num: chapter9.id) }
  let!(:decision56)     { FactoryGirl.create(:decision, chapter: chapter5, destiny_num: chapter6.id) }
  let!(:decision57)     { FactoryGirl.create(:decision, chapter: chapter5, destiny_num: chapter7.id, item_validator: item1.id) }
  let!(:decision910)    { FactoryGirl.create(:decision, chapter: chapter9, destiny_num: chapter10.id) }
  let!(:decision1011)   { FactoryGirl.create(:decision, chapter: chapter10, destiny_num: chapter11.id, item_validator: item1.id) }
  
  let!(:modifier_item1) { FactoryGirl.create(:modifier_item, chapter: chapter1, item: item3, quantity: 1) }
  let!(:modifier_item2) { FactoryGirl.create(:modifier_item, chapter: chapter1, item: item4, quantity: 2) }

  let!(:monster)        { FactoryGirl.create(:monster, chapter: chapter2, name: "goblin", skill: 1, energy: 1) }

  let!(:modifier_item)  { FactoryGirl.create(:modifier_item, chapter: chapter3, item: item, quantity: 1) }
  let!(:modifier_item3) { FactoryGirl.create(:modifier_item, chapter: chapter9, item: item1, quantity: 1) }
  let!(:modifier_item4) { FactoryGirl.create(:modifier_item, chapter: chapter10, item: item5, quantity: 1) }

  let!(:shop)           { FactoryGirl.create(:modifier_shop, chapter: chapter8, item: item3, price: 5, quantity: 2) }
  let!(:shop2)          { FactoryGirl.create(:modifier_shop, chapter: chapter8, item: item1, price: 18, quantity: 1) }

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

      expect(page).to have_text("História foi criada com sucesso.")
      expect(current_path).to eql("/stories/#{Story.last.slug}/edit")
    end

    scenario "user fails to create story" do
      visit "/stories/new"

      fill_in "Título", with: ""
      fill_in "Resumo", with: ""
      fill_in "Prelúdio", with: ""

      click_button "Próximo"

      expect(current_path).to eql("/stories/new")
      expect(page).to have_text("Title não deve estar em branco")
      expect(page).to have_text("Resume não deve estar em branco")
      expect(page).to have_text("Chapter numbers não deve estar em branco")
      expect(page).to have_text("Chapter numbers não é um número")
    end
  end

  feature "#delete story", js: true do

    before(:each) do
      login_as user
    end

    scenario "user deletes a story" do
      visit "/profile/#{user.id}"

      expect(page).to have_text("Titulo")
      first(:link, "Deletar história").click
      page.driver.browser.switch_to.alert.accept
      sleep(0.5)
      expect(Story.count).to eq 1
      expect(current_path).to eql("/profile/#{user.id}")
    end
  end

  feature "#read story" do

    before(:each) do
      login_as user
    end

    scenario "user passes through chapters", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 2"
      expect(page).to have_text("content 2")

      expect(page).to have_button 'Combat'
      click_button "Combate"

      click_link "Capítulo 5"
      expect(page).to have_text("content 5")
    end

    scenario "user does combat", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 2"

      expect(page).to have_button 'Combat'

      click_button "Combate"
      expect(page).to have_text("goblin morreu!")
    end

    scenario "user receives an item", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 3"
      expect(page).to have_text("espada")
    end

    scenario "user does not has an item", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 2"
      expect(page).to have_text("content 2")

      expect(page).to have_button('Combat')
      click_button "Combate"

      click_link "Capítulo 5"
      expect(page).to have_text("content 5")
      expect(page).to have_css(".disabled")
    end

    scenario "user has an item and passes through", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 8"
      expect(page).to have_text("content 8")

      sleep(0.2)
      expect(page.body).to include("<strike>Pastel</strike>")
    end

    scenario "user uses an usable item and it depletes", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      adventurer = Adventurer.last
      adventurer.energy = 5
      adventurer.save

      expect(page).to have_text("content 1")

      
      click_link "Capítulo 2"
      expect(page).to have_text("content 2")

      click_link "Pastel"

      sleep(0.5)
      expect(Adventurer.last.energy).to eql(9)

      sleep(0.5)
      expect(page.body).to include("<strike>pastel</strike>")
    end

    scenario "user uses an usable item and it does not deplete", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      adventurer = Adventurer.last
      adventurer.energy = 5
      adventurer.save

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 2"
      expect(page).to have_text("content 2")

      click_link "health drink"

      sleep(0.5)
      expect(Adventurer.last.energy).to eql(9)

      sleep(0.5)
      expect(page.body).to have_text("health drink - 1")
    end

    scenario "user buy an item", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")

      click_link "Capítulo 8"

      click_link "Pastel"

      expect(page).to have_text("Pastel - 1")
      expect(page).to have_text("Ouro: 15")
      expect(page).to have_text("Sua compra foi bem sucedida.")
    end

    scenario "user buy an item but does not has enough gold", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")

      click_link "Capítulo 8"

      click_link "Pastel"
      sleep(0.5)
      first(:link, "Pastel").click

      expect(page).to have_text("Pastel - 1")
      expect(page).to have_text("Ouro: 10")

      click_link "espada"

      page.should have_text "Não foi possível comprar este item."
    end

    scenario 'user select one of the weapons', js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"

      click_button "Capítulo 1"
      click_link "Capítulo 2"
      click_button "Combate"
      click_link "Capítulo 9"
      click_link "Capítulo 10"
      click_link "espada"

      sleep(0.2)

      adventurer = Adventurer.last
      adventurer_item = adventurer.adventurers_items.find_by(item: item1)

      expect(adventurer_item.selected).to eql(true)
      expect(page).to have_text('Arma escolhida com sucesso.')
    end

    scenario 'user loses one of the weapons', js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      
      click_button "Capítulo 1"
      click_link "Capítulo 2"
      click_button "Combate"
      click_link "Capítulo 9"
      click_link "Capítulo 10"
      click_link "espada"
      click_link "Capítulo 11"

      sleep(0.2)

      adventurer = story_sample.adventurers.last
      adventurer_item = adventurer.adventurers_items.find_by(item: item1)

      expect(adventurer_item.selected).to eql(false)
      expect(adventurer_item.quantity).to eql(0)
      
      sleep(0.2)
      expect(page.body).to include("<strike>espada</strike>")
    end

    scenario "user continues from where he stoped", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 8"
      expect(page).to have_text("content 8")

      visit "/profile/#{user.id}"

      find(:xpath, "//a[@href='/stories/#{story_sample.slug}/detail']").click
      click_link "Ler história"
      click_link "Continuar"

      expect(page).to have_text("content 8")
    end

    scenario "user start story from beginning", js: true do
      visit "/stories/#{story_sample.slug}/prelude?new_story=true"

      click_button "Rolar dados"
      click_button "Capítulo 1"

      expect(page).to have_text("content 1")
      
      click_link "Capítulo 8"
      expect(page).to have_text("content 8")

      visit "/profile/#{user.id}"

      find(:xpath, "//a[@href='/stories/#{story_sample.slug}/detail']").click
      click_link "Ler história"
      click_link "Começar do Início"

      expect(page).to have_text("Prelúdio")
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
        expect(page).not_to have_text("Unpublished Story")

        visit "/stories/#{unpublished_story.id}/edit"

        first(:link, "Publicar").click
        expect(page).to have_text("Publicado com sucesso.")

        visit root_path
        expect(page).to have_text("Unpublished Story")
      end
    end

    context "user unpublish a story" do
      let!(:published_story) { FactoryGirl.create(:story, title: 'Published Story', published: true, user: user, chapter_numbers: 0) }

      scenario "user unpublish a story", js: true do
        visit root_path
        expect(page).to have_text("Published Story")

        visit "/stories/#{published_story.id}/edit"

        first(:link, "Despublicar").click
        expect(page).to have_text("Despublicado com sucesso.")

        visit root_path
        expect(page).not_to have_text("Published Story")
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
      expect(page).to have_text("Story sample")
      expect(current_path).to eql("/stories/search_result")
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

      first(:link, "+5 capítulos").click
      expect(story_sample2.chapters.count).to eql(10)
    end

    scenario "user adds 10 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:link, "+10 capítulos").click
      expect(story_sample2.chapters.count).to eql(15)
    end

    scenario "user adds 20 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:link, "+20 capítulos").click
      expect(story_sample2.chapters.count).to eql(25)
    end

    scenario "user adds 50 chapters" do
      visit "/stories/#{story_sample2.id}/edit"

      first(:button, "Adicionar capítulos").click
      first(:link, "+50 capítulos").click
      expect(story_sample2.chapters.count).to eql(55)
    end
  end

  feature "remove chapters" do
    let!(:story_sample3) { FactoryGirl.create(:story, title: "Story sample", published: true, user: user, chapter_numbers: 50) }

    before(:each) do
      story = Story.last
      story.chapters.destroy_all
      for i in (1..50)
        story_sample3.chapters.build(reference: "#{i}", content: "content #{i}")
      end
      story_sample3.save
      login_as user
    end

    scenario "user removes 5 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:link, "-5 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      expect(story_sample3.chapters.count).to eql(45)
    end

    scenario "user removes 10 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:link, "-10 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      expect(story_sample3.chapters.count).to eql(40)
    end

    scenario "user removes 20 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:link, "-20 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      expect(story_sample3.chapters.count).to eql(30)
    end

    scenario "user removes 50 chapters", js: true do
      visit "/stories/#{story_sample3.id}/edit"

      first(:button, "Remover capítulos").click
      first(:link, "-50 capítulos").click
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      expect(story_sample3.chapters.count).to eql(0)
    end
  end
end
