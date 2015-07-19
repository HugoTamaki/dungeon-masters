# == Schema Information
#
# Table name: favorite_stories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe FavoriteStory do
  let(:favorite_story) {FactoryGirl.create(:favorite_story)}

  describe "Attributes" do
    it {should have_attribute :user_id}
    it {should have_attribute :story_id}
  end

  describe "Relationships" do
    it {should respond_to :user}
    it {should respond_to :story}
  end
end
