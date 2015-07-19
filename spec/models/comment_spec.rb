# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Comment do
  let(:story)   {FactoryGirl.create(:story)}
  let(:user)    {FactoryGirl.create(:user)}
  let(:comment) {FactoryGirl.create(:comment, story: story, user: user)}

  describe "Attributes" do
    it {should have_attribute :user_id}
    it {should have_attribute :story_id}
    it {should have_attribute :content}
  end

  describe "Relationships" do
    it {should respond_to :user}
    it {should respond_to :story}
  end

  describe "Validations" do
    describe "of attributes" do
      context "#content" do
        context "is valid" do
          it "when present" do
            expect(comment.save).to eq(true)
          end
        end

        context "is invalid" do
          it "when absent" do
            comment.content = nil
            expect(comment.save).to eq(false)
          end
        end
      end
    end
  end
end
