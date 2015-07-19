# == Schema Information
#
# Table name: adventurers_shops
#
#  id               :integer          not null, primary key
#  adventurer_id    :integer
#  modifier_shop_id :integer
#  quantity         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe AdventurerShop do
  let(:adventurer_shop) {FactoryGirl.create(:adventurer_shop)}

  describe "Atributos" do
    it {should have_attribute :adventurer_id}
    it {should have_attribute :modifier_shop_id}
    it {should have_attribute :quantity}
  end

  describe "Relacionamentos" do
    it {should respond_to :adventurer}
    it {should respond_to :modifier_shop}
  end
end
