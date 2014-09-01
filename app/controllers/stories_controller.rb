class StoriesController < ApplicationController

  # before_filter :authenticate_user!, except: [:prelude, :read, :search, :index]
  # load_and_authorize_resource except: [:prelude, :read]
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.by_user(current_user.id).page(params[:page]).per(5)

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
    if @story.published || @story.user == current_user
      if current_user.adventurer.present?
        @adventurer = Adventurer.new
        current_user.adventurer.items.clear
        current_user.adventurer.chapters.clear
      else
        @adventurer = Adventurer.new
      end
    else
      redirect_to root_url, alert: I18n.t('actions.not_published')
    end
  end

  def read
    @story = Story.find(params[:id])
    if @story.published || @story.user == current_user
      @chapter = @story.chapters.where(reference: params[:reference]).first
      adventurer = Adventurer.by_user(current_user.id).first

      @adventurer = Adventurer.attribute_and_item_changer(adventurer, @chapter) unless @adventurer && @chapter
      @adventurers_items = AdventurerItem.by_adventurer(@adventurer)
      @adventurer.chapters << @chapter unless @adventurer.chapters.include? @chapter

      this_decision = Decision.find_by(destiny_num: @chapter.id)
      Adventurer.use_required_item(this_decision, @adventurer)

      
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @chapter }
      end
    else
      redirect_to root_url, alert: I18n.t('actions.not_published')
    end
  end

  def search_result
    @stories = Story.search(params[:search]).published.page(params[:page]).per(5)
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
    adventurer_item.quantity -= 1

    if adventurer_item.save
      data = {
        name: adventurer_item.item.name.parameterize.underscore,
        skill: adventurer.skill,
        energy: adventurer.energy,
        luck: adventurer.luck,
        gold: adventurer.gold,
        quantity: adventurer_item.quantity,
        message: I18n.t('actions.messages.adventurer_update_success')
      }
    else
      data = {
        message: I18n.t('actions.messages.adventurer_update_fail')
      }
    end

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

  def publish
    story = Story.find(params[:story_id])
    publish_story(story)
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
        @errors = get_errors(@story)
        format.html { redirect_to new_story_path, alert: {errors: @errors} }
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

    def publish_story(story)
      if story.published
        story.published = false
      else
        story.published = true
      end

      if story.save
        if story.published
          data = {
            button: I18n.t('actions.unpublish'),
            message: I18n.t('actions.publish_success')
          }
        else
          data = {
            button: I18n.t('actions.publish'),
            message: I18n.t('actions.unpublish_success')
          }
        end
        respond_to do |format|
          format.json { render json: data.to_json }
        end
      else
        if story.published
          data = {
            message: I18n.t('actions.unpublish_fail')
          }
        else
          data = {
            message: I18n.t('actions.publish_fail')
          }
        end
        respond_to do |format|
          format.json { render json: data.to_json }
        end
      end
    end

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
        when I18n.t('actions.five_more')
          add_chapters(story,5)
        when I18n.t('actions.ten_more')
          add_chapters(story,10)
        when I18n.t('actions.twenty_more')
          add_chapters(story,20)
        when I18n.t('actions.fifty_more')
          add_chapters(story,50)
        when I18n.t('actions.five_less')
          remove_chapters(story,5)
        when I18n.t('actions.ten_less')
          remove_chapters(story,10)
        when I18n.t('actions.twenty_less')
          remove_chapters(story,20)
        when I18n.t('actions.fifty_less')
          remove_chapters(story,50)
        else
          redirect_to story, notice: I18n.t('actions.messages.update_success')
      end
    end

    def add_chapters(story,num_chapters)
      if story.chapters.present?
        last_chapter_reference = story.chapters.last.reference.to_i + 1
      else
        last_chapter_reference = 1
      end
      quantity = num_chapters - 1

      for i in (last_chapter_reference..(last_chapter_reference + quantity))
        chapter = story.chapters.build
        chapter.decisions.build
        chapter.reference = i
        chapter.save
      end
      story.chapter_numbers = story.chapters.last.reference.to_i
      story.save

      case num_chapters
      when 5
        message = I18n.t('actions.messages.five_more')
      when 10
        message = I18n.t('actions.messages.ten_more')
      when 20
        message = I18n.t('actions.messages.twenty_more')
      when 50
        message = I18n.t('actions.messages.fifty_more')
      end
      redirect_to edit_story_path(story), notice: message
    end

    def remove_chapters(story, num_chapters)
      quantity = num_chapters
      chapter_quantity = story.chapters.count
      quantity = chapter_quantity if chapter_quantity <= quantity

      quantity.times do
        last_chapter = story.reload.chapters.last
        last_chapter.decisions.each do |decision|
          decision.destroy
        end
        story.reload.chapters.last.destroy
      end

      case num_chapters
      when 5
        message = I18n.t('actions.messages.five_less')
      when 10
        message = I18n.t('actions.messages.ten_less')
      when 20
        message = I18n.t('actions.messages.twenty_less')
      when 50
        message = I18n.t('actions.messages.fifty_less')
      end

      redirect_to edit_story_path(story), notice: message
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
                                    :published,
                                    :chapter_numbers,
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
                                                          modifiers_items_attributes: [:id, :chapter_id, :item_id, :quantity, :_destroy, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                                          modifiers_attributes_attributes: [:id, :attr, :chapter_id, :quantity, :_destroy],
                                                          items_attributes: [:id, :description, :name, :story_id, :_destroy],
                                                          ]) if params[:story]
    end
end
