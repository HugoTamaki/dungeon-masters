# encoding: UTF-8
# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(40)
#  description :text
#  story_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  usable      :boolean
#  attr        :string(255)
#  modifier    :integer
#

require "spec_helper"

describe Item do
  let(:item) {FactoryGirl.build(:item)}

  describe "Atributos" do
    it {should have_attribute :name}
    it {should have_attribute :description}
    it {should have_attribute :story_id}
  end

  describe "Relacionamentos" do
    it {should respond_to :story}
    it {should respond_to :adventurers}
    it {should respond_to :modifiers_items}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#name" do
        context "é valido quando" do
          it "está preenchido" do
            item.name = "nome do item"
            item.should have(0).errors_on :name
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            item.name = ""
            item.should_not have(0).errors_on :name
          end
        end
      end

      describe "#description" do
        context "é valido quando" do
          it "está preenchido" do
            item.description = "alguma descrição"
            item.should have(0).errors_on :description
          end
        end

        context "é inválido quando" do
          it "não está preenchido" do
            item.description = ""
            item.should_not have(0).errors_on :description
          end
        end
      end
    end

  end
end
