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
#  usable      :boolean          default(FALSE)
#  attr        :string(255)      default("")
#  modifier    :integer          default(0)
#

require "spec_helper"

describe Item do
  let(:item) {FactoryGirl.build(:item)}

  describe "Attributes" do
    it {should have_attribute :name}
    it {should have_attribute :description}
    it {should have_attribute :story_id}
  end

  describe "Relationships" do
    it {should respond_to :story}
    it {should respond_to :adventurers}
    it {should respond_to :modifiers_items}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#name" do
        context "is valid" do
          it "when present" do
            item.name = "nome do item"
            item.should have(0).errors_on :name
          end
        end

        context "is invalid" do
          it "when not present" do
            item.name = ""
            item.should_not have(0).errors_on :name
          end
        end
      end

      describe "#description" do
        context "is valid" do
          it "when present" do
            item.description = "alguma descrição"
            item.should have(0).errors_on :description
          end
        end

        context "is invalid" do
          it "when not present" do
            item.description = ""
            item.should_not have(0).errors_on :description
          end
        end
      end
    end

  end
end
