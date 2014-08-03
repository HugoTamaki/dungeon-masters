class CustomPagesController < ApplicationController
  def index
    @stories = Story.published.last(8)
  end
end
