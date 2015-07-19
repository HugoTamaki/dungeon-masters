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

  describe "Attributes" do
    it {should have_attribute :attr}
    it {should have_attribute :chapter_id}
    it {should have_attribute :quantity}
  end

  describe "Relationships" do
    it {should respond_to :chapter}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#attr" do
        context "is valid" do
          it "when present" do
            modifier_attribute.attr = "algum atributo"
            modifier_attribute.should have(0).errors_on :attr
          end
        end

        context "is invalid" do
          it "when not present" do
            modifier_attribute.attr = ""
            modifier_attribute.should_not have(0).errors_on :attr
          end
        end
      end

      describe "#quantity" do
        context "is valid" do
          it "when present" do
            modifier_attribute.quantity = 1
            modifier_attribute.should have(0).errors_on :quantity
          end
        end

        context "is invalid" do
          it "when not present" do
            modifier_attribute.quantity = ""
            modifier_attribute.should_not have(0).errors_on :quantity
          end

          it "when not a number" do
            modifier_attribute.quantity = "abc"
            modifier_attribute.should_not have(0).errors_on :quantity
          end
        end
      end
    end
  end
end
