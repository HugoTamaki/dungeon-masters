class AdventurersController < ApplicationController
  def create

    adventurer = Adventurer.by_user(current_user.id)

    respond_to do |format|
      if adventurer.empty?
        @adventurer = Adventurer.new(params[:adventurer])
        if @adventurer.save
          options = {reference: params[:reference], id: params[:story_id]}
          format.html { redirect_to read_stories_path(options) }
        else
          format.html { redirect_to :back, alert: "Adventurer attributes not valid." }
        end
      else
        @adventurer = Adventurer.by_user(current_user.id).first
        if @adventurer.update_attributes(params[:adventurer])
          options = {reference: params[:reference], id: params[:story_id]}
          format.html { redirect_to read_stories_path(options) }
        else
          format.html { redirect_to :back, alert: "Adventurer attributes not valid." }
        end
      end

    end
  end

end
