class CustomPagesController < ApplicationController
  def index
    @stories = Story.last(8)
  end
end
