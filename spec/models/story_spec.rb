# encoding: UTF-8
# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  title              :string(40)
#  resume             :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  prelude            :text
#  cover              :string(255)
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  published          :boolean          default(FALSE)
#  chapter_numbers    :integer
#  initial_gold       :integer          default(0)
#

require "spec_helper"

describe Story do
  let(:story) { FactoryGirl.build(:story) }

  describe "Attributes" do
    it {should have_attribute :title }
    it {should have_attribute :resume}
    it {should have_attribute :prelude}
    it {should have_attribute :user_id}
    it {should have_attribute :cover_file_name}
    it {should have_attribute :cover_content_type}
    it {should have_attribute :cover_file_size}
    it {should have_attribute :cover_updated_at}
    it {should have_attribute :initial_gold}
    it {should have_attribute :published}
    it {should have_attribute :chapter_numbers}
  end

  describe "Relationships" do
    it {should respond_to :user}
    it {should respond_to :chapters}
    it {should respond_to :items}
    it {should respond_to :favorite_stories}
    it {should respond_to :favorited_by}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#title" do
        context "is valid" do
          it "when its filled" do
            story.title = "Titulo qualquer"
            story.should have(0).errors_on :title
          end
        end

        context "is invalid" do
          it "when not filled" do
            story.title = ""
            story.should_not have(0).errors_on :title
          end
        end
      end

      describe "#resume" do
        context "is valid" do
          it "when its filled" do
            story.resume = "um resumo qualquer"
            story.should have(0).errors_on :resume
          end
        end

        context "is invalid" do
          it "when not filled" do
            story.resume = ""
            story.should_not have(0).errors_on :resume
          end
        end
      end

      describe "#cover" do
        context "is valid" do
          it "when size is less than 2MB" do
            story.cover = File.new("#{Rails.root}/spec/photos/test.png")
            story.should have(0).errors_on :cover
          end
        end

        context "is invalid" do
          it "size is bigger then 300k" do
            story.cover = File.new("#{Rails.root}/spec/photos/test2.jpg")
            story.should_not have(0).errors_on :cover
          end
        end
      end
    end
  end

  describe :methods do
    let!(:story_with_adventurer) {FactoryGirl.create(:story, title: "story with adventurer", chapter_numbers: 10)}
    let!(:user_with_adventurer) {FactoryGirl.create(:user, email: "email1@email.com")}
    let!(:user_without_adventurer) {FactoryGirl.create(:user, email: "email2@email.com")}
    let!(:adventurer) {FactoryGirl.create(:adventurer, story: story_with_adventurer, user: user_with_adventurer)}

    describe ".has_adventurer?" do
      context "user has one adventurer for the story" do
        it "return true" do
          story_with_adventurer.has_adventurer?(user_with_adventurer.adventurers).should eq true
        end
      end

      context "user does not have adventurer of story" do
        it "return false" do
          story_with_adventurer.has_adventurer?(user_without_adventurer.adventurers).should eq false
        end
      end
    end

    describe ".graph" do
      let!(:chapter1)    {FactoryGirl.create(:chapter, reference: "1", x: 0.5, y: 0.5, content: "content 1", story: story_with_adventurer)}
      let!(:chapter2)    {FactoryGirl.create(:chapter, reference: "2", x: 0.5, y: 0.5, content: "content 2", story: story_with_adventurer)}
      let!(:chapter3)    {FactoryGirl.create(:chapter, reference: "3", x: 0.5, y: 0.5, content: "content 3", story: story_with_adventurer)}
      let!(:chapter4)    {FactoryGirl.create(:chapter, reference: "4", x: 0.5, y: 0.5, content: "content 4", story: story_with_adventurer)}
      let!(:chapter5)    {FactoryGirl.create(:chapter, reference: "5", x: 0.5, y: 0.5, content: "content 5", story: story_with_adventurer)}
      let!(:chapter6)    {FactoryGirl.create(:chapter, reference: "6", x: 0.5, y: 0.5, content: "content 6", story: story_with_adventurer)}
      let!(:chapter7)    {FactoryGirl.create(:chapter, reference: "7", x: 0.5, y: 0.5, content: "content 7", story: story_with_adventurer)}
      let!(:chapter8)    {FactoryGirl.create(:chapter, reference: "8", x: 0.5, y: 0.5, content: "content 8", story: story_with_adventurer)}
      let!(:chapter9)    {FactoryGirl.create(:chapter, reference: "9", x: 0.5, y: 0.5, content: "content 9", story: story_with_adventurer)}
      let!(:chapter10)   {FactoryGirl.create(:chapter, reference: "10", x: 0.5, y: 0.5, content: "content 10", story: story_with_adventurer)}
      let!(:decision1_4) {FactoryGirl.create(:decision, chapter_id: chapter1.id, destiny_num: chapter4.id)}
      let!(:decision1_7) {FactoryGirl.create(:decision, chapter_id: chapter1.id, destiny_num: chapter7.id)}
      let!(:decision4_8) {FactoryGirl.create(:decision, chapter_id: chapter4.id, destiny_num: chapter8.id)}
      let!(:decision7_3) {FactoryGirl.create(:decision, chapter_id: chapter7.id, destiny_num: chapter3.id)}

      it "prepare json for graph" do
        pending "need to check float numbers equality"
        graph = Story.graph(story_with_adventurer.chapters)

        expect(graph[:references]).to match(
            [
              {:number=>"1", :x=>chapter1.x, :y=>chapter1.y, :color=>chapter1.color, :description=>"content 1"},
              {:number=>"3", :x=>chapter3.x, :y=>chapter3.y, :color=>chapter3.color, :description=>"content 3"},
              {:number=>"4", :x=>chapter4.x, :y=>chapter4.y, :color=>chapter4.color, :description=>"content 4"},
              {:number=>"7", :x=>chapter7.x, :y=>chapter7.y, :color=>chapter7.color, :description=>"content 7"},
              {:number=>"8", :x=>chapter8.x, :y=>chapter8.y, :color=>chapter8.color, :description=>"content 8"}
            ]
          )

        expect(graph[:chapter_destinies]).to match(
            [
              {:source=>"1", :destinies=>[4, 7], :infos=>[chapter1.x, chapter1.y, chapter1.color]},
              {:source=>"3", :destinies=>[], :infos=>[chapter3.x, chapter3.y, chapter3.color]},
              {:source=>"4", :destinies=>[8], :infos=>[chapter4.x, chapter4.y, chapter4.color]},
              {:source=>"7", :destinies=>[3], :infos=>[chapter7.x, chapter7.y, chapter7.color]},
              {:source=>"8", :destinies=>[], :infos=>[chapter8.x, chapter8.y, chapter8.color]}
            ]
          )

        expect(graph[:not_used]).to match(
            [chapter2.reference, chapter5.reference, chapter6.reference, chapter9.reference, chapter10.reference]
          )

        expect(graph[:valid]).to eql(true)
      end
    end

    describe ".search" do
      it "return search for terms" do
        search = Story.search("story")
        search.first.should == story_with_adventurer
      end
    end
  end

end
