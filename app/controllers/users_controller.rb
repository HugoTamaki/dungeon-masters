class UsersController < ApplicationController
  before_filter :authenticate_user!

  def profile
    @user = User.find(params[:id])
    @stories = @user.stories
  end
end
