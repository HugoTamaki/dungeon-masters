# == Schema Information
#
# Table name: modifiers_shops
#
#  id         :integer          not null, primary key
#  chapter_id :integer
#  item_id    :integer
#  price      :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ModifierShop do
  let!(:story)        {FactoryGirl.create(:story)}
  let!(:chapter)      {FactoryGirl.create(:chapter, story: story)}
  let!(:item)         {FactoryGirl.create(:item)}
  let(:modifier_shop) { FactoryGirl.create(:modifier_shop, chapter: chapter, item: item) }

  describe "Attributes" do
    it {should have_attribute :chapter_id}
    it {should have_attribute :item_id}
    it {should have_attribute :price}
    it {should have_attribute :quantity}
  end

  describe "Relationships" do
    it {should respond_to :chapter}
    it {should respond_to :item}
    it {should respond_to :adventurers_shops}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#price" do
        context "is valid" do
          it "when present" do
            expect(modifier_shop.save).to eql(true)
          end

          it "when numerical" do
            expect(modifier_shop.save).to eql(true)
          end
        end

        context "is invalid" do
          it "when absent" do
            modifier_shop.price = nil
            expect(modifier_shop.save).to eq(false)
          end

          it "when not numerical" do
            modifier_shop.price = "not a number"
            expect(modifier_shop.save).to eq(false)
          end
        end
      end

      describe "#quantity" do
        context "is valid" do
          it "when present" do
            expect(modifier_shop.save).to eql(true)
          end

          it "when numerical" do
            expect(modifier_shop.save).to eql(true)
          end
        end

        context "is invalid" do
          it "when absent" do
            modifier_shop.quantity = nil
            expect(modifier_shop.save).to eq(false)
          end

          it "when not numerical" do
            modifier_shop.quantity = "not a number"
            expect(modifier_shop.save).to eq(false)
          end
        end
      end
    end
  end
end
