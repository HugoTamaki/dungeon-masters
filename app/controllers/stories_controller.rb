class StoriesController < ApplicationController

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
    @adventurer = Adventurer.by_user(current_user.id).first
    @adventurers_items = AdventurerItem.by_adventurer(@adventurer)

    Adventurer.attribute_changer(@adventurer, @chapter)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chapter }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
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
    chapters = Chapter.by_story(params[:id])
    @chapters = chapters.includes(:decisions, :monsters)
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
  
  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to edit_story_path(id: @story, chapter_numbers: params[:story][:chapter_numbers]), notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { redirect_to new_story_path, alert: 'some parameters are missing' }
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

    if @story.update_attributes(params[:story])
      redirect_story(@story, params)
    else
      respond_to do |format|
        format.html { render action: :edit, controller: :stories }
        format.json { render json: @story.errors, status: :unprocessable_entity }
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

    def redirect_story(story, params)
      case params[:commit]
        when "Save"
          redirect_to :back, notice: 'Story was successfully saved.'
        when "Edit Items"
          redirect_to story_edit_items_path(story), notice: 'Data saved'
        when "Edit Special Attributes"
          redirect_to story_edit_special_attributes_path(story), notice: 'Data saved'
        when "Edit Chapters"
          redirect_to edit_story_path(story), notice: 'Data saved'
        when "Graph"
          redirect_to story_graph_path(story), notice: 'Data saved.'
        when "Edit Monters"
          redirect_to story_edit_monsters_path(story), notice: 'Data saved.'
        else
          redirect_to story, notice: 'Story was successfully updated.'
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
                                    items_attributes: [:id, :description, :name, :story_id, :_destroy],
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
                                                          decisions_attributes: [:id, :destiny_num, :chapter_id, :_destroy],
                                                          monsters_attributes: [:id, :skill, :energy, :name, :chapter_id, :_destroy],
                                                          modifiers_items_attributes: [:id, :chapter_id, :item_id, :quantity, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                                          modifiers_attributes_attributes: [:id, :attr, :chapter_id, :quantity, :_destroy],
                                                          items_attributes: [:id, :description, :name, :story_id, :_destroy],
                                                          ])
    end
end
