# encoding: UTF-8
require "spec_helper"

describe Chapter do
  let(:chapter) { FactoryGirl.build(:chapter) }

  describe "Atributos" do
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

  describe "Relacionamentos" do
    it {should respond_to :story}
    it {should respond_to :decisions}
    it {should respond_to :monsters}
    it {should respond_to :modifiers_items}
    it {should respond_to :modifiers_attributes}
  end

  describe "Validacoes" do
    describe "de atributos" do
      describe "#image" do
        context "é valido quando" do
          it "é menor que 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test.png")
            chapter.should have(0).errors_on :image
          end
        end

        context "é invalido quando" do
          it "é maior que 300k" do
            chapter.image = File.new("#{Rails.root}/spec/photos/test2.jpg")
            chapter.should_not have(0).errors_on :image
          end
        end
      end
    end
  end
end