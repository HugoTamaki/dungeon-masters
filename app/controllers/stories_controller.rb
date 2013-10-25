class StoriesController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.by_user(current_user.id)

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
    @chapters = @story.chapters

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  def read
    story = Story.find(params[:id])
    @story = story.id
    @chapter = story.chapters.where(reference: params[:reference]).first

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
    @chapters = Chapter.by_story(params[:id])
  end

  def edit_items
    @story = Story.find(params[:story_id])
    @items = @story.items
  end

  def edit_special_attributes
    
    @story = Story.find(params[:story_id])
    @spcial_attributes = @story.special_attributes

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

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        if params[:commit] == "Save"
          format.html { redirect_to edit_story_path(@story), notice: 'Story was successfully saved.' }
        elsif params[:commit] == "Edit Special Attributes"
          format.html { redirect_to story_edit_special_attributes_path(@story), notice: 'Data was successfully saved.' }
        elsif params[:commit] == "Edit Items"
          format.html { redirect_to story_edit_items_path(@story), notice: 'Data was successfully saved.' }
        elsif params[:commit] == "Edit Chapters"
          format.html { redirect_to edit_story_path(@story), notice: 'Data was successfully saved.' }
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
