# encoding: UTF-8
# == Schema Information
#
# Table name: monsters
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  skill      :integer
#  energy     :integer
#  chapter_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe Monster do
  let(:monster) {FactoryGirl.build(:monster)}

  describe "Attributes" do
    it {should have_attribute :name}
    it {should have_attribute :skill}
    it {should have_attribute :chapter_id}
  end

  describe "Relationships" do
    it {should respond_to :chapter}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#name" do
        context "is valid" do
          it "when present" do
            monster.name = "monster"
            monster.should have(0).errors_on :name
          end
        end

        context "is invalid" do
          it "when not present" do
            monster.name = nil
            monster.should_not have(0).errors_on :name
          end
        end
      end

      describe "#skill" do
        context "is valid" do
          it "when present" do
            monster.skill = 1
            monster.should have(0).errors_on :skill
          end
        end

        context "is invalid" do
          it "when not present" do
            monster.skill = nil
            monster.should_not have(0).errors_on :skill
          end

          it "when not a number" do
            monster.skill = "abc"
            monster.should_not have(0).errors_on :skill
          end
        end
      end

      describe "#energy" do
        context "is valid" do
          it "when present" do
            monster.energy = 1
            monster.should have(0).errors_on :energy
          end
        end

        context "is invalid" do
          it "when not present" do
            monster.energy = nil
            monster.should_not have(0).errors_on :energy
          end

          it "when not a number" do
            monster.energy = "abc"
            monster.should_not have(0).errors_on :energy
          end
        end
      end
    end
  end
end
