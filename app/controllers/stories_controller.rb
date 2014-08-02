class StoriesController < ApplicationController

  # before_filter :authenticate_user!, except: [:prelude, :read, :search, :index]
  # load_and_authorize_resource except: [:prelude, :read]
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.search(params[:search],current_user.id).page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])
    @items = @story.items
    @special_attributes = @story.special_attributes
    @chapters = @story.chapters.includes(:decisions)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  def prelude
    @story = Story.find(params[:story_id])
    if current_user.adventurer.present?
      @adventurer = Adventurer.new
      current_user.adventurer.items.clear
    else
      @adventurer = Adventurer.new
    end
  end

  def read
    @story = Story.find(params[:id])
    @chapter = @story.chapters.where(reference: params[:reference]).first
    adventurer = Adventurer.by_user(current_user.id).first

    @adventurer = Adventurer.attribute_and_item_changer(adventurer, @chapter) unless @adventurer && @chapter
    @adventurers_items = AdventurerItem.by_adventurer(@adventurer)

    this_decision = Decision.find_by(destiny_num: @chapter.id)
    Adventurer.use_required_item(this_decision, @adventurer)

    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chapter }
    end
  end

  def new
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
  chapter_numbers = params[:chapter_numbers].to_i
  @story = Story.includes(:chapters, :items, :special_attributes).find(params[:id])

  if @story.chapters.empty?
    if chapter_numbers.present?
      for i in (1..chapter_numbers)
        chapter = @story.chapters.build
        chapter.decisions.build
        chapter.reference = i
        chapter.save
      end
    else
      chapter = @story.chapters.build
      chapter.decisions.build
    end
  end
  # chapters = Chapter.by_story(params[:id])
  # @chapters = chapters.includes(:decisions, :monsters)
  @chapters = @story.chapters
end

  def edit_items
    @story = Story.find(params[:story_id])
    if @story.items.empty?
      item = @story.items.build
    end
  end

  def edit_special_attributes
    @story = Story.find(params[:story_id])
    if @story.special_attributes.empty?
      special_attributes = @story.special_attributes.build
    end
  end

  def graph
    @story = Story.find(params[:story_id])
  end

  def graph_json
    chapters_of_story = Chapter.by_story(params[:id])
    chapters = chapters_of_story.includes(:decisions)

    @chapters = Story.graph(chapters)

    respond_to do |format|
      format.json { render json: @chapters.to_json }
    end

  end

  def graph_json_show
    chapters_of_story = Chapter.by_story(params[:id])
    chapters = chapters_of_story.includes(:decisions)

    @chapters = Story.graph(chapters)

    respond_to do |format|
      format.json { render json: @chapters.to_json }
    end
  end

  def use_item
    adventurer = current_user.adventurer
    adventurer_item = adventurer.adventurers_items.find_by(item_id: params["item-id"])
    Adventurer.change_attribute(adventurer, params[:attribute], params[:modifier])
    adventurer_item.status = 0
    adventurer_item.save

    data = {
      name: adventurer_item.item.name.parameterize.underscore,
      skill: adventurer.skill,
      energy: adventurer.energy,
      luck: adventurer.luck,
      gold: adventurer.gold
    }

    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  def erase_image
    current_chapter = Chapter.find(params[:chapter_id])
    current_chapter.image_file_name = nil
    current_chapter.image_content_type = nil
    current_chapter.image_file_size = 0
    current_chapter.save

    render nothing: true
  end
  
  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to edit_story_path(id: @story, chapter_numbers: params[:story][:chapter_numbers]), notice: I18n.t('actions.messages.create_success') }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { redirect_to new_story_path, alert: I18n.t('actions.messages.params_missing') }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_tabs
    @story = Story.find(params[:story_id].to_i)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { render nothing: true}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    if @story.update_attributes(story_params)
      redirect_story(@story, params)
    else
      @errors = get_errors(@story)
      @chapters_with_errors = get_chapters_with_errors(@story)
      respond_to do |format|
        format.html { render action: :edit, controller: :stories }
        format.json { render json: {errors: @errors.to_json, 
                                    chapters_with_errors: @chapters_with_errors}, 
                                    status: :unprocessable_entity }
      end
    end
  end

  def auto_save
    @story = Story.find(params[:story_id].to_i)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { render nothing: true}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end
  
  private

    def get_errors(story)
      errors = []
      story.errors.full_messages.each do |error|
        errors << error
      end
      errors
    end

    def get_chapters_with_errors(story)
      chapters = ""
      story.chapters.each do |chapter|
        if chapter.errors.any?
          chapters << chapter.reference + ", "
        end
      end
      chapters[0...-2]
    end

    def redirect_story(story, params)
      case params[:commit]
        when I18n.t('actions.save')
          redirect_to :back, notice: I18n.t('actions.messages.save_success')
        when I18n.t('actions.edit_items')
          redirect_to story_edit_items_path(story), notice: I18n.t('actions.messages.data_saved')
        when I18n.t('actions.edit_special_attributes')
          redirect_to story_edit_special_attributes_path(story), notice: I18n.t('actions.messages.save_success')
        when I18n.t('actions.edit_chapters')
          redirect_to edit_story_path(story), notice: I18n.t('actions.messages.data_saved')
        when I18n.t('actions.graph')
          redirect_to story_graph_path(story), notice: I18n.t('actions.messages.save_success')
        when I18n.t('actions.edit_monsters')
          redirect_to story_edit_monsters_path(story), notice: I18n.t('actions.messages.save_success')
        else
          redirect_to story, notice: I18n.t('actions.messages.update_success')
      end
    end

    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:resume,
                                    :title,
                                    :prelude,
                                    :user_id,
                                    :chapter_numbers,
                                    :cover,
                                    items_attributes: [:id, :description, :name, :story_id, :usable, :attr, :modifier, :_destroy],
                                    special_attributes_attributes: [:id, :adventurer_id, :name, :value, :story_id, :_destroy],
                                    chapters_attributes: [:id,
                                                          :content,
                                                          :reference,
                                                          :story_id,
                                                          :image,
                                                          :x,
                                                          :y,
                                                          :color,
                                                          :_destroy,
                                                          decisions_attributes: [:id, :destiny_num, :chapter_id, :item_validator, :_destroy],
                                                          monsters_attributes: [:id, :skill, :energy, :name, :chapter_id, :_destroy],
                                                          modifiers_items_attributes: [:id, :chapter_id, :item_id, :quantity, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                                          modifiers_attributes_attributes: [:id, :attr, :chapter_id, :quantity, :_destroy],
                                                          items_attributes: [:id, :description, :name, :story_id, :_destroy],
                                                          ]) if params[:story]
    end
end
