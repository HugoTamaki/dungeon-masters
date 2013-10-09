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

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = Story.new
    #    @story.chapters.build
    @story.special_attributes.build
    @story.items.build
    chapter = @story.chapters.build
    chapter.decisions.build
    #    @story.chapters.decisions.build
    #    3.times do
    #      chapter = @story.chapters.build
    #      special_attribute = @story.special_attributes.build
    #      item = @story.items.build
    #    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
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
      if params[:commit] == "Save"
        if @story.update_attributes(params[:story])
          format.html { redirect_to edit_story_path(@story), notice: 'Story was successfully saved.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @story.errors, status: :unprocessable_entity }
        end
      else
        if @story.update_attributes(params[:story])
          format.html { redirect_to @story, notice: 'Story was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @story.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def auto_save
    @story = Story.find(params[:story_id].to_i)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        binding.pry
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
