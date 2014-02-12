# encoding: UTF-8
require "spec_helper"

describe ModifierItem do
  let(:modifier_item) { FactoryGirl.build(:modifier_item) }

  describe "Atributos" do
    it {should have_attribute :item_id}
    it {should have_attribute :chapter_id}
    it {should have_attribute :quantity}
  end

  describe "Relacionamentos" do
    it {should respond_to :chapter}
    it {should respond_to :item}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#quantity" do
        context "é valido quando" do
          it "está preenchido" do
            modifier_item.quantity = 1
            modifier_item.should have(0).errors_on :quantity
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            modifier_item.quantity = nil
            modifier_item.should_not have(0).errors_on :quantity
          end

          it "não é numérico" do
            modifier_item.quantity = "abc"
            modifier_item.should_not have(0).errors_on :quantity
          end
        end
      end
    end
  end
end