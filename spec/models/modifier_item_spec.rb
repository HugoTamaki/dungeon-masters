# encoding: UTF-8
# == Schema Information
#
# Table name: modifiers_items
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  item_id    :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe ModifierItem do
  let(:modifier_item) { FactoryGirl.build(:modifier_item) }

  describe "Attributes" do
    it {should have_attribute :item_id}
    it {should have_attribute :chapter_id}
    it {should have_attribute :quantity}
  end

  describe "Relationships" do
    it {should respond_to :chapter}
    it {should respond_to :item}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#quantity" do
        context "is valid" do
          it "when present" do
            modifier_item.quantity = 1
            modifier_item.should have(0).errors_on :quantity
          end
        end

        context "is invalid" do
          it "when not present" do
            modifier_item.quantity = nil
            modifier_item.should_not have(0).errors_on :quantity
          end

          it "when not a number" do
            modifier_item.quantity = "abc"
            modifier_item.should_not have(0).errors_on :quantity
          end
        end
      end
    end
  end
end
