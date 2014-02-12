# encoding: UTF-8
require "spec_helper"

describe Decision do
  let(:decision) {FactoryGirl.build(:decision)}

  describe "Atributos" do
    it {should have_attribute :destiny_num}
    it {should have_attribute :chapter_id}
  end

  describe "Relacionamentos" do
    it {should respond_to :chapter}
  end
end