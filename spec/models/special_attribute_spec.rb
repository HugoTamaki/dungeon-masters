# encoding: UTF-8
require "spec_helper"

describe SpecialAttribute do
  let(:special_attribute) {FactoryGirl.build(:special_attribute)}

  describe "Atributos" do
    it {should have_attribute :name}
    it {should have_attribute :adventurer_id}
    it {should have_attribute :story_id}
    it {should have_attribute :value}
  end

  describe "Relacionamentos" do
    it {should respond_to :adventurer}
    it {should respond_to :story}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#name" do
        context "é valido quando" do
          it "está preenchido" do
            special_attribute.name = "atributo"
            special_attribute.should have(0).errors_on :name
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            special_attribute.name = nil
            special_attribute.should_not have(0).errors_on :name
          end
        end
      end
    end
  end
end