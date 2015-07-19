# encoding: UTF-8
# == Schema Information
#
# Table name: decisions
#
#  id             :integer          not null, primary key
#  chapter_id     :integer
#  destiny_num    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  item_validator :integer
#

require "spec_helper"

describe Decision do
  let(:decision) {FactoryGirl.build(:decision)}

  describe "Attributes" do
    it {should have_attribute :destiny_num}
    it {should have_attribute :chapter_id}
  end

  describe "Relationships" do
    it {should respond_to :chapter}
  end
end
