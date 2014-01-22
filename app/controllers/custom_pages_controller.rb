class CustomPagesController < ApplicationController
  def index
    @stories = Kaminari.paginate_array(Story.last(10)).page(params[:page]).per(5)
  end
end
