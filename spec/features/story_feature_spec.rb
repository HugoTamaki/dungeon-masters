require 'spec_helper'

feature "Story" do
  let(:user) {FactoryGirl.create :user}
  let!(:story) {FactoryGirl.create(:story, user_id: user.id)}
  let!(:item) {FactoryGirl.create(:item, story_id: story.id)}

  feature "#create Story" do
    before(:each) do
      login_as user
    end

    scenario "user creates story successfully" do
      visit "/stories/new"

      fill_in "Title", with: "Titulo"
      fill_in "Resume", with: "Resumo"
      fill_in "Prelude", with: "Preludio"
      fill_in "Chapter numbers", with: 5

      click_button "Next"

      page.should have_text("Story was successfully created.")
      current_path.should == "/stories/#{Story.last.id}/edit" 
    end

    scenario "user fails to create story" do
      visit "/stories/new"

      fill_in "Title", with: ""
      fill_in "Resume", with: ""
      fill_in "Prelude", with: ""

      click_button "Next"

      current_path.should == "/stories/new"
      page.should have_text("some parameters are missing")
    end
  end

  feature "#create chapters" do

    before(:each) do
      login_as user
    end

    scenario "user creates story successfully", js: true do
      visit "/stories/#{story.id}/edit"

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
      page.should have_text("Story was successfully updated.")
    end

    scenario "user creates story without success", js: true do
      visit "/stories/#{story.id}/edit"

      click_link "Add chapters"
      fill_in "Reference", with: ""
      fill_in "Content", with: ""
      click_link "Add monsters"
      fill_in "Name", with: "monster"

      first(:button, "Finish Editing").click
      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("Chapters monsters skill can't be blank")
      page.should have_text("Chapters monsters skill is not a number")
      page.should have_text("Chapters monsters energy can't be blank")
      page.should have_text("Chapters monsters energy is not a number")
    end
  end

  feature "#create items" do
    before(:each) do
      login_as user
    end

    scenario "user creates item successfully" do
      visit "stories/#{story.id}/edit_items"

      fill_in "Name", with: "Escudo"
      fill_in "Description", with: "um escudo"

      click_button "Edit Chapters"

      current_path.should == "/stories/#{Story.last.id}/edit"
      page.should have_text("Data saved")
      Item.last.name.should == "Escudo"
      Item.last.description.should == "um escudo"
    end

    scenario "user fails to create item" do
      visit "stories/#{story.id}/edit_items"

      fill_in "Name", with: ""
      fill_in "Description", with: "um escudo"

      click_button "Edit Chapters"

      current_path.should == "/stories/#{Story.last.id}"
      page.should have_text("Items name can't be blank")
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
      click_link("Destroy")
      page.driver.browser.switch_to.alert.accept
      page.should have_text("No stories.")
      current_path.should == "/stories"
    end
  end

  feature "#read story" do
    let(:story_sample) {FactoryGirl.create(:story, user_id: user.id)}

    before(:each) do
      for i in (1..5)
        story_sample.chapters.build(reference: "#{i}", content: "content #{i}")
      end
      story_sample.items.build(name: "espada", description: "uma espada")
      story_sample.save

      story_sample.chapters[0].decisions.build(destiny_num: 2)
      story_sample.chapters[0].decisions.build(destiny_num: 3)
      story_sample.chapters[2].modifiers_items.build(item_id: Item.last.id, quantity: 1)
      story_sample.chapters[1].decisions.build(destiny_num: 5)
      story_sample.chapters[1].monsters.build(name: "goblin",skill: 1, energy: 1)
      story_sample.save   
      login_as user
    end

    scenario "user passes through chapters", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Roll dices"
      click_button "Chapter 1"

      page.should have_text("content 1")
      
      click_link "Chapter 2"
      page.should have_text("content 2")

      click_link "Chapter 5"
      page.should have_text("content 5")
    end

    scenario "user does combat", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Roll dices"

      click_button "Chapter 1"
      click_link "Chapter 2"

      page.should have_button 'Combat'

      click_button "Combat"
      page.should have_text("goblin died!")
    end

    scenario "user receives an item", js: true do
      visit "/stories/#{story_sample.id}/prelude"

      click_button "Roll dices"

      click_button "Chapter 1"
      click_link "Chapter 3"
      page.should have_text("espada")
    end
  end
end