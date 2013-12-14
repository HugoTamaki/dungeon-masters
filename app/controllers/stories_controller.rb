class StoriesController < ApplicationController

  before_filter :authenticate_user!
  
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
  end

  def read
    @story = Story.find(params[:id])
    @chapter = @story.chapters.where(reference: params[:reference]).first

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
    @story = Story.find(params[:id])
    if @story.chapters.empty? and @story.special_attributes.empty? and @story.items.empty?
      @story.special_attributes.build
      @story.items.build
      chapter = @story.chapters.build
      chapter.decisions.build
    end
    chapters = Chapter.by_story(params[:id])
    @chapters = chapters.includes(:decisions)
  end

  def edit_items
    @story = Story.find(params[:story_id])
  end

  def edit_special_attributes
    @story = Story.find(params[:story_id])
  end

  def graph
    @story = Story.find(params[:story_id])
  end

  def graph_json
    chapters_of_story = Chapter.by_story(params[:id])
    chapters = chapters_of_story.includes(:decisions)

    @chapters = Story.graph(chapters,params[:id])

    respond_to do |format|
      format.json { render json: @chapters.to_json }
    end

  end

  def graph_json_show
    chapters_of_story = Chapter.by_story(params[:id])
    chapters = chapters_of_story.includes(:decisions)

    @chapters = Story.graph(chapters,params[:id])

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
        format.html { redirect_to edit_story_path(@story), notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_tabs
    @story = Story.find(params[:story_id].to_i)
    binding.pry

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

    respond_to do |format|
      if @story.update_attributes(params[:story])
        if params[:commit] == "Save"
          format.html { redirect_to :back, notice: 'Story was successfully saved.' }
        elsif params[:commit] == "Edit Items"
          format.html { redirect_to story_edit_items_path(@story), notice: 'Data saved' }
        elsif params[:commit] == "Edit Special Attributes"
          format.html { redirect_to story_edit_special_attributes_path(@story), notice: 'Data saved' }
        elsif params[:commit] == "Edit Chapters"
          format.html { redirect_to edit_story_path(@story), notice: 'Data saved' }
        elsif params[:commit] == "Graph"
          format.html { redirect_to story_graph_path(@story), notice: 'Data saved.' }
        elsif params[:commit] == "Edit Monsters"
          format.html { redirect_to story_edit_monsters_path(@story), notice: 'Data saved.' }
        else
          format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
end
