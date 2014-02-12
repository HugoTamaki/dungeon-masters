# encoding: UTF-8
require "spec_helper"

describe Adventurer do
  let(:adventurer) {FactoryGirl.build(:adventurer)}

  describe "Atributos" do
    it {should have_attribute :name}
    it {should have_attribute :skill}
    it {should have_attribute :energy}
    it {should have_attribute :luck}
    it {should have_attribute :gold}
    it {should have_attribute :user_id}
  end

  describe "Relacionamentos" do
    it {should respond_to :user}
    it {should respond_to :adventurers_items}
    it {should respond_to :items}
    it {should respond_to :special_attributes}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#skill" do
        context "é valido quando" do
          it "está preenchido" do
            adventurer.skill = 1
            adventurer.should have(0).errors_on :skill
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
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
        context "é valido quando" do
          it "está preenchido" do
            adventurer.energy = 1
            adventurer.should have(0).errors_on :energy
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
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
        context "é valido quando" do
          it "está preenchido" do
            adventurer.luck = 1
            adventurer.should have(0).errors_on :luck
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            adventurer.luck = nil
            adventurer.should_not have(0).errors_on :luck
          end

          it "não é numérico" do
            adventurer.luck = "abc"
            adventurer.should_not have(0).errors_on :luck
          end
        end
      end
    end
  end
end