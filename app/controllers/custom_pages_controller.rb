class CustomPagesController < ApplicationController
  def index
    @stories = Story.last(5)
  end
end
