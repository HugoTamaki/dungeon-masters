require 'spec_helper'

feature "Story" do
  let(:user) {FactoryGirl.create :user}

  feature "#create Story" do
    before(:each) do
      login_as user
    end

    scenario "user creates story successfully" do
      
    end
  end
end