#encoding: UTF-8
require 'spec_helper'


feature "CRUD de história", js: true do

  before :each do
    login
  end

  feature "Criar história - " do
    scenario "usuário cria nova história com sucesso" do
      visit "/stories/new"

      fill_in "Title", with: "Titulo"
      fill_in "Resume", with: "Resumo"
      fill_in "Prelude", with: "Preludio"
      fill_in "Chapter numbers", with: 5

      click_button "Next"

      expect(page).to have_text("Story was successfully created.")
      current_path.should == "/stories/#{Story.last.id}/edit"
    end

    scenario "usuário cria nova história com dados errados" do
      visit "/stories/new"

      fill_in "Title", with: ""
      fill_in "Resume", with: ""
      fill_in "Prelude", with: ""

      click_button "Next"

      current_path.should == "/stories/new"
      expect(page).to have_text("some parameters are missing")
    end
  end

  feature "Preencher capítulos - " do

    before :each do
      cria_historia_com_sucesso
      editando_items
    end

    scenario "usuário cria um capitulo com sucesso" do
      click_link "Add chapters"
      fill_in "Reference", with: "Referencia"
      fill_in "Content", with: "Conteudo"
      click_link "Add decisions"
      fill_in "Destiny", with: 5
      click_link "Add monsters"
      fill_in "Name", with: "monster"
      fill_in "Skill", with: 5
      fill_in "Energy", with: 5
      click_link "Add items"
      select "espada", from: "Item"
      fill_in "Quantity", with: 1

      first(:button, "Finish Editing").click
      current_path.should == "/stories/#{Story.last.id}"
      expect(page).to have_text("Story was successfully updated.")
    end
    
    scenario "usuário cria um capitulo sem sucesso" do
      click_link "Add chapters"
      fill_in "Reference", with: ""
      fill_in "Content", with: ""
      click_link "Add monsters"
      fill_in "Name", with: "monster"

      first(:button, "Finish Editing").click
      current_path.should == "/stories/#{Story.last.id}"
      expect(page).to have_text("Chapters monsters skill can't be blank")
      expect(page).to have_text("Chapters monsters skill is not a number")
      expect(page).to have_text("Chapters monsters energy can't be blank")
      expect(page).to have_text("Chapters monsters energy is not a number")

    end
  end

  feature "Criar Items - " do

    before :each do
      cria_historia_com_sucesso
    end

    scenario "Criando itens associados à história com sucesso" do
      first(:button, "Edit Items").click
      fill_in "Name", with: "Espada"
      fill_in "Description", with: "uma espada"

      click_button "Edit Chapters"

      current_path.should == "/stories/#{Story.last.id}/edit"
      expect(page).to have_text("Data saved")
    end

    scenario "Criando itens associados à história sem sucesso" do
      first(:button, "Edit Items").click
      fill_in "Name", with: "espada"
      fill_in "Description", with: ""

      click_button "Edit Chapters"

      current_path.should == "/stories/#{Story.last.id}"
      expect(page).to have_text("Items description can't be blank")
    end
    
  end
  
  feature "Deletar história - " do
    scenario "Deletando história" do
      story = FactoryGirl.build(:story)
      user = User.last
      user.stories << story

      visit "/stories"
      expect(page).to have_text("Titulo")
      click_link("Destroy")
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text("No stories.")
      current_path.should == "/stories"
    end
  end

  feature "Ler uma historia - " do
    before :each do
      criar_historia_com_capitulos
    end

    scenario "Testando conexão dos capitulos" do
      visit "/stories"

      expect(page).to have_text("Titulo")
      click_link("Read")
      expect(page).to have_text("Prelude")
      click_button "Roll dices"
      
      click_button "Chapter 1"
      expect(page).to have_text("content 1")
      
      click_link "Chapter 2"
      expect(page).to have_text("content 2")

      click_link "Chapter 5"
      expect(page).to have_text("content 5")
    end

    scenario "Testando combate" do
      visit "/stories"

      click_link "Read"
      click_button "Roll dices"
      click_button "Chapter 1"
      click_link "Chapter 2"

      page.should have_button 'Combat'

      click_button "Combat"
      expect(page).to have_text("goblin died!")
    end

    scenario "Testando recebimento de items" do
      visit "/stories"

      click_link "Read"
      click_button "Roll dices"
      click_button "Chapter 1"
      click_link "Chapter 3"

      expect(page).to have_text("espada")
    end
  end
end

def login
  user = FactoryGirl.create(:user)
  visit "/users/sign_in"

  fill_in "Email", with: user.email
  fill_in "Password", with: '11111111'

  click_button "Sign in"
end

def editando_items
  click_button "Edit Items"

  fill_in "Name", with: "espada"
  fill_in "Description", with: "uma espada"

  click_button "Edit Chapters"
end

def cria_historia_com_sucesso
  visit "/stories/new"

  fill_in "Title", with: "Titulo"
  fill_in "Resume", with: "Resumo"
  fill_in "Prelude", with: "Preludio"
  fill_in "Chapter numbers", with: 1

  click_button "Next"
end

def criar_historia_com_capitulos
#  criando uma história com 5 capitulos, o capitulo 1 aponta para 2 e 3, e o capitulo 2 aponta para 5
#  - O capitulo 3 tem um modificador de item (espada)
#  - O capítulo 2 também tem um monstro (goblin)

  story = FactoryGirl.build(:story)
  user = User.last
  user.stories << story
  for i in (1..5)
    story.chapters.build(reference: "#{i}", content: "content #{i}")
  end

  story.items.build(name: "espada", description: "uma espada")
  story.save

  story.chapters[0].decisions.build(destiny_num: 2)
  story.chapters[0].decisions.build(destiny_num: 3)
  story.chapters[2].modifiers_items.build(item_id: Item.last.id, quantity: 1)
  story.chapters[1].decisions.build(destiny_num: 5)
  story.chapters[1].monsters.build(name: "goblin",skill: 1, energy: 1)
  story.save
  
end