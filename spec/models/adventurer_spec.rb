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
  let(:adventurer) {FactoryGirl.build(:adventurer)}

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
end
