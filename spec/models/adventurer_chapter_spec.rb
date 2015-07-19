# == Schema Information
#
# Table name: adventurer_chapters
#
#  id            :integer          not null, primary key
#  adventurer_id :integer
#  chapter_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe AdventurerChapter do
  let(:adventurer_chapter) {FactoryGirl.create(:adventurer_chapter)}

  describe "Attributes" do
    it {should have_attribute :adventurer_id}
    it {should have_attribute :chapter_id}
  end

  describe "Relationships" do
    it {should respond_to :adventurer}
    it {should respond_to :chapter}
  end
end
