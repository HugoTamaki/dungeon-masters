# encoding: UTF-8
require "spec_helper"

describe Story do
  let(:story) { FactoryGirl.build(:story) }

  describe "Atributos" do
    it {should have_attribute :title }
    it {should have_attribute :resume}
    it {should have_attribute :prelude}
    it {should have_attribute :user_id}
    it {should have_attribute :cover}
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