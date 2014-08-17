# encoding: UTF-8
# == Schema Information
#
# Table name: modifiers_attributes
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  attr       :string(255)
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe ModifierAttribute do
  let(:modifier_attribute) { FactoryGirl.build(:modifier_attribute) }

  describe "Atributos" do
    it {should have_attribute :attr}
    it {should have_attribute :chapter_id}
    it {should have_attribute :quantity}
  end

  describe "Relacionamentos" do
    it {should respond_to :chapter}
  end

  describe "Validacoes" do
    describe "de atributos" do
      describe "#attr" do
        context "é valido quando" do
          it "está preenchido" do
            modifier_attribute.attr = "algum atributo"
            modifier_attribute.should have(0).errors_on :attr
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            modifier_attribute.attr = ""
            modifier_attribute.should_not have(0).errors_on :attr
          end
        end
      end

      describe "#quantity" do
        context "é valido quando" do
          it "está preenchido" do
            modifier_attribute.quantity = 1
            modifier_attribute.should have(0).errors_on :quantity
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            modifier_attribute.quantity = ""
            modifier_attribute.should_not have(0).errors_on :quantity
          end

          it "não é um número" do
            modifier_attribute.quantity = "abc"
            modifier_attribute.should_not have(0).errors_on :quantity
          end
        end
      end
    end
  end
end
