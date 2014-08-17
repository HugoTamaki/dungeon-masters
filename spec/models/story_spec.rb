# encoding: UTF-8
# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  title              :string(40)
#  resume             :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  prelude            :text
#  cover              :string(255)
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  published          :boolean          default(FALSE)
#  chapter_numbers    :integer
#

require "spec_helper"

describe Story do
  let(:story) { FactoryGirl.build(:story) }

  describe "Atributos" do
    it {should have_attribute :title }
    it {should have_attribute :resume}
    it {should have_attribute :prelude}
    it {should have_attribute :user_id}
    it {should have_attribute :cover_file_name}
    it {should have_attribute :cover_content_type}
    it {should have_attribute :cover_file_size}
    it {should have_attribute :cover_updated_at}
  end

  describe "Relacionamentos" do
    it {should respond_to :user}
    it {should respond_to :chapters}
    it {should respond_to :items}
    it {should respond_to :special_attributes}
  end

  describe "Validações" do
    describe "de atributos" do
      describe "#title" do
        context "é valido quando" do
          it "está preenchido" do
            story.title = "Titulo qualquer"
            story.should have(0).errors_on :title
          end
        end

        context "é invalido quando" do
          it "nao está preenchido" do
            story.title = ""
            story.should_not have(0).errors_on :title
          end
        end
      end

      describe "#resume" do
        context "é valido quando" do
          it "está preenchido" do
            story.resume = "um resumo qualquer"
            story.should have(0).errors_on :resume
          end
        end

        context "é invalido quando" do
          it "não esta preenchido" do
            story.resume = ""
            story.should_not have(0).errors_on :resume
          end
        end
      end

      describe "#cover" do
        context "é valido quando" do
          it "é menor que 300K" do
            story.cover = File.new("#{Rails.root}/spec/photos/test.png")
            story.should have(0).errors_on :cover
          end
        end

        context "é invalido quando" do
          it "é maior que 300K" do
            story.cover = File.new("#{Rails.root}/spec/photos/test2.jpg")
            story.should_not have(0).errors_on :cover
          end
        end
      end
    end
  end

end
