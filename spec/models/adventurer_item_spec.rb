# encoding: UTF-8
require "spec_helper"

describe AdventurerItem do
  let(:adventurer_item) {FactoryGirl.build(:adventurer_item)}

  describe "Atributos" do
    it {should have_attribute :adventurer_id}
    it {should have_attribute :item_id}
    it {should have_attribute :status}
  end

  describe "Relacionamentos" do
    it {should respond_to :adventurer}
    it {should respond_to :item}
  end
end