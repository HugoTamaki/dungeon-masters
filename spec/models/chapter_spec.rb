# encoding: UTF-8
# == Schema Information
#
# Table name: chapters
#
#  id                 :integer          not null, primary key
#  story_id           :integer
#  reference          :string(10)
#  content            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  x                  :float
#  y                  :float
#  color              :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require "spec_helper"

describe Chapter do
  let(:chapter) { FactoryGirl.build(:chapter) }

  describe "Attributes" do
    it {should have_attribute :content}
    it {should have_attribute :reference}
    it {should have_attribute :story_id}
    it {should have_attribute :image_file_name}
    it {should have_attribute :image_content_type}
    it {should have_attribute :image_file_size}
    it {should have_attribute :image_updated_at}
    it {should have_attribute :x}
    it {should have_attribute :y}
    it {should have_attribute :color}

  end

  describe "Relationships" do
    it {should respond_to :story}
    it {should respond_to :decisions}
    it {should respond_to :monsters}
    it {should respond_to :modifiers_items}
    it {should respond_to :modifiers_attributes}
  end

  describe "Validations" do
    describe "of attributes" do
      describe "#image" do
        context "is valid" do
          it "when less than 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test.png")
            chapter.should have(0).errors_on :image
          end
        end

        context "is valid" do
          it "when more than 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test2.jpg")
            chapter.should_not have(0).errors_on :image
          end
        end
      end
    end
  end
end
