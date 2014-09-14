require 'spec_helper'

feature Item do
  let(:user) {FactoryGirl.create :user}
  let!(:story) {FactoryGirl.create(:story, user_id: user.id, chapter_numbers: 10)}
  let!(:item) {FactoryGirl.create(:item, story_id: story.id)}
  let!(:adventurer) {FactoryGirl.create(:adventurer, user_id: user.id, skill: 5, energy: 5, luck: 5)}

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
end