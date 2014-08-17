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

  describe "Atributos" do
    it {should have_attribute :name}
    it {should have_attribute :skill}
    it {should have_attribute :chapter_id}
  end

  describe "Relacionamentos" do
    it {should respond_to :chapter}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#name" do
        context "é valido quando" do
          it "está preenchido" do
            monster.name = "monster"
            monster.should have(0).errors_on :name
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            monster.name = nil
            monster.should_not have(0).errors_on :name
          end
        end
      end

      describe "#skill" do
        context "é valido quando" do
          it "está preenchido" do
            monster.skill = 1
            monster.should have(0).errors_on :skill
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            monster.skill = nil
            monster.should_not have(0).errors_on :skill
          end

          it "não é numérico" do
            monster.skill = "abc"
            monster.should_not have(0).errors_on :skill
          end
        end
      end

      describe "#energy" do
        context "é valido quando" do
          it "está preenchido" do
            monster.energy = 1
            monster.should have(0).errors_on :energy
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            monster.energy = nil
            monster.should_not have(0).errors_on :energy
          end

          it "não é numérico" do
            monster.energy = "abc"
            monster.should_not have(0).errors_on :energy
          end
        end
      end
    end
  end
end
