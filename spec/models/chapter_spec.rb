# encoding: UTF-8
# == Schema Information
#
# Table name: chapters
#
#  id                 :integer          not null, primary key
#  story_id           :integer
#  reference          :string(10)
#  content            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  x                  :float
#  y                  :float
#  color              :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require "spec_helper"

describe Chapter do
  let(:chapter) { FactoryGirl.build(:chapter) }

  describe "Attributes" do
    it {should have_attribute :content}
    it {should have_attribute :reference}
    it {should have_attribute :story_id}
    it {should have_attribute :image_file_name}
    it {should have_attribute :image_content_type}
    it {should have_attribute :image_file_size}
    it {should have_attribute :image_updated_at}
    it {should have_attribute :x}
    it {should have_attribute :y}
    it {should have_attribute :color}

  end

  describe "Relationships" do
    it {should respond_to :story}
    it {should respond_to :decisions}
    it {should respond_to :monsters}
    it {should respond_to :modifiers_items}
    it {should respond_to :modifiers_attributes}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#image" do
        context "is valid" do
          it "when less than 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test.png")
            chapter.should have(0).errors_on :image
          end
        end

        context "is valid" do
          it "when more than 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test2.jpg")
            chapter.should_not have(0).errors_on :image
          end
        end
      end
    end
  end

  describe 'methods' do
    let(:story)   { FactoryGirl.create(:story) }
    let(:chapter) { FactoryGirl.create(:chapter, reference: "30", story: story) }

    describe '#parents' do
      let!(:parent1)   { FactoryGirl.create(:chapter, reference: "40", story: story) }
      let!(:decision1) { FactoryGirl.create(:decision, chapter: parent1, destiny_num: chapter.id) }
      let!(:parent2)   { FactoryGirl.create(:chapter, reference: "52", story: story) }
      let!(:decision2) { FactoryGirl.create(:decision, chapter: parent2, destiny_num: chapter.id) }

      it 'return parents of a chapter' do
        expect(chapter.parents).to include(parent1)
        expect(chapter.parents).to include(parent2)
      end
    end

    describe '#children' do
      let!(:child1)    { FactoryGirl.create(:chapter, reference: "32", story: story) }
      let!(:decision1) { FactoryGirl.create(:decision, chapter: chapter, destiny_num: child1.id) }
      let!(:child2)    { FactoryGirl.create(:chapter, reference: "45", story: story) }
      let!(:decision2) { FactoryGirl.create(:decision, chapter: chapter, destiny_num: child2.id) }

      it 'return children of a chapter' do
        expect(chapter.children).to include(child1)
        expect(chapter.children).to include(child2)
      end
    end

    describe '#check_parents' do
      context 'no parents at all' do
        it 'returns false' do
          expect(chapter.check_parents).to eql(false)
        end
      end

      context 'one or more parents' do
        let!(:parent1)   { FactoryGirl.create(:chapter, reference: "40", story: story) }
        let!(:decision1) { FactoryGirl.create(:decision, chapter: parent1, destiny_num: chapter.id) }

        it 'returns true' do
          expect(chapter.check_parents).to eql(true)
        end
      end
    end

    describe '#check_children' do
      context 'no children at all' do
        it 'returns false' do
          expect(chapter.check_children).to eql(false)
        end
      end

      context 'one or more children' do
        let!(:child1)    { FactoryGirl.create(:chapter, reference: "32", story: story) }
        let!(:decision1) { FactoryGirl.create(:decision, chapter: chapter, destiny_num: child1.id) }

        it 'returns true' do
          expect(chapter.check_children).to eql(true)
        end
      end
    end
  end

  describe 'callbacks' do
    let(:story)   { FactoryGirl.create(:story) }
    let(:chapter) { FactoryGirl.create(:chapter, reference: "30", story: story) }

    describe '#check_parent_and_children' do
      context 'chapter has children' do
        let!(:parent1)   { FactoryGirl.create(:chapter, reference: "40", story: story) }
        let!(:decision1) { FactoryGirl.create(:decision, chapter: parent1, destiny_num: chapter.id) }

        it 'update has_children attribute' do
          expect(chapter.has_parent).to eql(false)
          chapter.save
          expect(chapter.has_parent).to eql(true)
        end
      end

      context 'chapter has parent' do
        let!(:child1)    { FactoryGirl.create(:chapter, reference: "32", story: story) }
        let!(:decision1) { FactoryGirl.create(:decision, chapter: chapter, destiny_num: child1.id) }

        it 'update has_parent attribute' do
          expect(chapter.has_children).to eql(false)
          chapter.save
          expect(chapter.has_children).to eql(true)
        end
      end
    end
  end
end
