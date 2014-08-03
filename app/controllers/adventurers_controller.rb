class AdventurersController < ApplicationController
  def create

    adventurer = Adventurer.by_user(current_user.id)

    respond_to do |format|
      if adventurer.empty?
        @adventurer = Adventurer.new(adventurer_params)
        if @adventurer.save
          options = {reference: params[:reference], id: params[:story_id]}
          format.html { redirect_to read_stories_path(options) }
        else
          format.html { redirect_to :back, alert: "Adventurer attributes not valid." }
        end
      else
        @adventurer = Adventurer.by_user(current_user.id).first
        if @adventurer.update_attributes(adventurer_params)
          options = {reference: params[:reference], id: params[:story_id]}
          format.html { redirect_to read_stories_path(options) }
        else
          format.html { redirect_to :back, alert: "Adventurer attributes not valid." }
        end
      end

    end
  end

  def update_adventurer_status
    user = User.find(current_user.id)
    adventurer = user.adventurer

    params[:adventurer_skill] = params[:adventurer_skill].to_i unless params[:adventurer_skill].nil?
    params[:adventurer_energy] = params[:adventurer_energy].to_i unless params[:adventurer_energy].nil?
    params[:adventurer_luck] = params[:adventurer_luck].to_i unless params[:adventurer_luck].nil?

    args = {}
    args[:adventurer] = {}
    args[:adventurer][:skill] = params[:adventurer_skill]
    args[:adventurer][:energy] = params[:adventurer_energy]
    args[:adventurer][:luck] = params[:adventurer_luck]

    respond_to do |format|
      if adventurer.update_attributes(args[:adventurer])
        data = { message: I18n.t('actions.messages.adventurer_update_success') }
        format.json { render json: data.to_json }
      else
        data = { message: I18n.t('actions.messages.adventurer_update_fail') }
        format.json { render json: data.to_json }
      end
    end
  end

  private

    def set_adventurer
      @adventurer = Adventurer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adventurer_params
      params.require(:adventurer).permit(:skill, :energy, :gold, :luck, :name, :user_id)
    end

end
