class UsersController < ApplicationController
  before_filter :authenticate_user!

  def profile
    @user = User.find(params[:id])
    @stories = @user.stories
    @stories = @user.stories.published if current_user != @user
    @favorites = @user.favorites.published
  end
end
