# encoding: UTF-8
# == Schema Information
#
# Table name: adventurers
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  user_id    :integer
#  skill      :integer
#  energy     :integer
#  luck       :integer
#  gold       :integer
#  created_at :datetime
#  updated_at :datetime
#  chapter_id :integer
#  story_id   :integer
#

require "spec_helper"

describe Adventurer do
  let(:user) { FactoryGirl.create(:user) }
  let(:adventurer) { FactoryGirl.create(:adventurer, user: user) }

  describe "Attributes" do
    it {should have_attribute :name}
    it {should have_attribute :skill}
    it {should have_attribute :energy}
    it {should have_attribute :luck}
    it {should have_attribute :gold}
    it {should have_attribute :user_id}
  end

  describe "Relationships" do
    it {should respond_to :user}
    it {should respond_to :adventurers_items}
    it {should respond_to :items}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#skill" do
        context "is valid" do
          it "when present" do
            adventurer.skill = 1
            adventurer.should have(0).errors_on :skill
          end
        end

        context "is invalid" do
          it "when absent" do
            adventurer.skill = nil
            adventurer.should_not have(0).errors_on :skill
          end

          it "não é numérico" do
            adventurer.skill = "abc"
            adventurer.should_not have(0).errors_on :skill
          end
        end
      end

      describe "#energy" do
        context "is valid" do
          it "when present" do
            adventurer.energy = 1
            adventurer.should have(0).errors_on :energy
          end
        end

        context "is invalid" do
          it "when absent" do
            adventurer.energy = nil
            adventurer.should_not have(0).errors_on :energy
          end

          it "não é numérico" do
            adventurer.energy = "abc"
            adventurer.should_not have(0).errors_on :energy
          end
        end
      end

      describe "#luck" do
        context "is valid" do
          it "when present" do
            adventurer.luck = 1
            adventurer.should have(0).errors_on :luck
          end
        end

        context "is invalid" do
          it "when absent" do
            adventurer.luck = nil
            adventurer.should_not have(0).errors_on :luck
          end

          it "when not numeric" do
            adventurer.luck = "abc"
            adventurer.should_not have(0).errors_on :luck
          end
        end
      end
    end
  end

  describe '#methods' do
    let(:user)    { FactoryGirl.create(:user) }
    let(:story)   { FactoryGirl.create(:story, initial_gold: 30) }
    let(:chapter) { FactoryGirl.create(:chapter, reference: "30", story: story) }

    describe '#set_chapter_and_gold' do
      before(:each) do
        adventurer.user = user
        adventurer.save
      end

      context 'should maintain same gold' do
        it 'should set chapter, story and reference of an adventurer' do
          adventurer.set_chapter_and_gold(chapter, story, "30")
          expect(adventurer.chapter).to eq(chapter)
          expect(adventurer.story).to eq(story)
          expect(adventurer.gold).to eq(adventurer.gold)
        end
      end

      context 'should update gold by story initial_gold' do
        it 'should set adventurer gold with story initial_gold' do
          adventurer.set_chapter_and_gold(chapter, story, "1")
          expect(adventurer.chapter).to eq(chapter)
          expect(adventurer.story).to eq(story)
          expect(adventurer.gold).to eq(30)
        end
      end
    end

    describe '#attribute_and_item_changer' do
      let(:item) { FactoryGirl.create(:item, story: story, usable: true, attr: 'energy', modifier: 4) }

      before do
        chapter.modifiers_attributes.create(attr: 'energy', quantity: 5)
        chapter.modifiers_items.create(item: item, quantity: 3)
      end

      context 'adventurer attributes' do
        it 'should change adventurer attributes' do
          adventurer.attribute_and_item_changer(chapter)
          expect(adventurer.energy).to eql(6)
        end
      end

      context 'adventurer items' do
        it 'should add item to adventurer' do
          expect(adventurer.items.count).to eql(0)

          adventurer.attribute_and_item_changer(chapter)
          adventurer_item = adventurer.adventurers_items.first

          expect(adventurer.items).to include(item)
          expect(adventurer.items.count).to eql(1)
          expect(adventurer_item.quantity).to eql(3)
          expect(adventurer_item.status).to eql(1)
        end

        it 'should update existing adventurer_item' do
          adventurer.items << item
          adventurer_item = adventurer.adventurers_items.first
          adventurer_item.quantity = 1
          adventurer_item.save

          expect(adventurer.reload.items.count).to eql(1)
          adventurer.attribute_and_item_changer(chapter)
          expect(adventurer.items).to include(item)
          expect(adventurer.items.count).to eql(1)
          expect(adventurer_item.reload.quantity).to eql(4)
          expect(adventurer_item.status).to eql(1)
        end
      end
    end

    describe '#dont_have_item' do
      let(:item) { FactoryGirl.create(:item, story: story, usable: true, attr: 'energy', modifier: 4) }

      context 'dont have item' do
        it 'dont have item at all' do
          expect(adventurer.dont_have_item(item)).to eql(true)
        end

        it 'have adventurer item, but its already used' do
          adventurer.items << item
          adventurer_item = adventurer.adventurers_items.first
          adventurer_item.quantity = 0
          adventurer_item.status = 0
          adventurer_item.save

          expect(adventurer.dont_have_item(item)).to eql(true)
        end
      end

      context 'have item' do
        it 'have item' do
          adventurer.items << item
          adventurer_item = adventurer.adventurers_items.first
          adventurer_item.quantity = 1
          adventurer_item.save

          expect(adventurer.dont_have_item(item)).to eql(false)
        end
      end
    end

    describe '#use_required_item' do
      let(:item) { FactoryGirl.create(:item, story: story, usable: true, attr: 'energy', modifier: 4) }
      let(:not_usable_item) { FactoryGirl.create(:item, story: story, usable: false) }
      let(:story)   { FactoryGirl.create(:story, initial_gold: 30) }
      let(:chapter) { FactoryGirl.create(:chapter, reference: "30", story: story) }
      let(:chapter2) { FactoryGirl.create(:chapter, reference: "46", story: story) }
      let(:decision) { FactoryGirl.create(:decision, chapter: chapter2) }

      context 'decision is nil' do
        it 'should do nothing with adventurer' do
          decision = nil
          adventurer.use_required_item decision
          expect(adventurer.changed?).to eql(false)
        end
      end

      context 'decision does not have item validation' do
        it 'should do nothing with adventurer' do
          adventurer.use_required_item decision
          expect(adventurer.changed?).to eql(false)
        end
      end

      context 'required item is usable' do
        it 'should update adventurer_item quantity and change attributes of adventurer' do
          adventurer.items << item
          adventurer_item = adventurer.adventurers_items.first
          adventurer_item.quantity = 1
          adventurer_item.save
          decision.item_validator = item.id
          decision.save

          adventurer.use_required_item(decision)
          expect(adventurer_item.reload.quantity).to eql(0)
          expect(adventurer.reload.energy).to eql(5)
        end
      end

      context 'required item is not usable' do
        it 'should not update adventurer attributes' do
          adventurer.items << not_usable_item
          adventurer_item = adventurer.adventurers_items.first
          adventurer_item.quantity = 1
          adventurer_item.save
          decision.item_validator = not_usable_item.id
          decision.save

          adventurer.use_required_item(decision)
          expect(adventurer_item.reload.quantity).to eql(0)
          expect(adventurer_item.reload.status).to eql(0)
        end
      end
    end

    describe '#change_attribute' do
      context 'change skill' do
        it 'changes skill of adventurer' do
          adventurer.change_attribute('skill', 5)
          expect(adventurer.skill).to eq(6)
        end
        
        it 'does not rise higher than 12' do
          adventurer.change_attribute('skill', 20)
          expect(adventurer.skill).to eq(12)
        end
      end

      context 'change energy' do
        it 'changes energy of adventurer' do
          adventurer.change_attribute('energy', 5)
          expect(adventurer.energy).to eq(6)
        end
        
        it 'does not rise higher than 24' do
          adventurer.change_attribute('energy', 30)
          expect(adventurer.energy).to eq(24)
        end
      end

      context 'change luck' do
        it 'changes luck of adventurer' do
          adventurer.change_attribute('luck', 5)
          expect(adventurer.luck).to eq(6)
        end
        
        it 'does not rise higher than 12' do
          adventurer.change_attribute('luck', 20)
          expect(adventurer.luck).to eq(12)
        end
      end
    end
  end
end
