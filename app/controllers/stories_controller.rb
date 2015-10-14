class StoriesController < ApplicationController

  # before_filter :authenticate_user!, except: [:prelude, :read, :search, :index]
  # load_and_authorize_resource except: [:prelude, :read]
  before_filter :authenticate_user!, except: [:search_result, :detail]
  load_and_authorize_resource except: [:search_result, :favorite, :detail]
  
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.by_user(current_user.id).page(params[:page]).per(5)
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])
    @items = @story.items
    @chapters = @story.chapters.includes(:decisions)
  end

  def detail
    @story = Story.find(params[:story_id])
  end

  def prelude
    @story = Story.find(params[:story_id])
    if @story.published || @story.user == current_user
      @adventurer = Adventurer.by_user_and_story(current_user, @story).first
      if params[:new_story]
        @adventurer = Adventurer.clear_or_create_adventurer(@adventurer, params[:story_id])
      else
        redirect_to story_read_path(@story, continue: true, chapter_id: @adventurer.chapter.id, adventurer_id: @adventurer.id)
      end
    else
      redirect_to root_url, alert: I18n.t('actions.not_published')
    end
  end

  def read
    @story = Story.find(params[:story_id])
    if @story.published || @story.user == current_user
      if params[:continue]
        @chapter = Chapter.find(params[:chapter_id])
        @adventurer = Adventurer.find(params[:adventurer_id])
        @adventurers_items = AdventurerItem.by_adventurer(@adventurer)
      else
        @chapter = @story.chapters.find_by reference: params[:reference]
        if @story && @story.has_adventurer?(current_user.adventurers) && @chapter.present?
          set_gold_items_and_attributes(current_user)
          this_decision = Decision.find_by(destiny_num: @chapter.id)
          @adventurer.use_required_item(this_decision)
        else
          redirect_to root_url, alert: I18n.t('actions.not_found')
        end
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
  end

  # GET /stories/1/edit
  def edit
    chapter_numbers = params[:chapter_numbers].to_i
    @story = Story.includes(:chapters, :items).find(params[:id])

    if @story.chapters.empty?
      if params[:chapter_numbers].present?
        @story.build_chapters(chapter_numbers)
      else
        chapter = @story.chapters.build
        chapter.decisions.build
      end
    end
    @chapter_count = @story.chapters.count
    @chapters = @story.chapters.page(params[:page]).per(10)
    @all_chapters = @story.chapters
    @page = params[:page]
    params[:change_page] == 'true' ? @last_chapter = nil : @last_chapter = params[:last_chapter]
  end

  def edit_story
    @story = Story.find(params[:story_id])
  end

  def edit_items
    @story = Story.find(params[:story_id])
    if @story.items.empty?
      item = @story.items.build
    end
  end

  def favorite
    type = params[:type]
    story = Story.find(params[:id])
    if type == "favorite"
      current_user.favorites << story
      redirect_to :back, notice: "Você favoritou #{story.title}"
    elsif type == "unfavorite"
      current_user.favorites.delete(story)
      redirect_to :back, notice: "Você deixou de favoritar #{story.title}"
    else
      redirect_to :back, notice: 'Nada aconteceu.'
    end
  end

  def update_chapter_number
    @story = Story.find(params[:story_id])

    quantity = params[:quantity].to_i

    params[:type] == 'sum' ? add_chapters(@story, quantity) : remove_chapters(@story, quantity)
  end

  def graph
    @story = Story.find(params[:story_id])
  end

  def graph_json
    chapters = Chapter.includes(:decisions).by_story(params[:id])
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

  def node_update
    chapter = Chapter.by_story(params[:id]).where(reference: params[:cap].gsub("Cap ","")).first
    chapter.x = params[:x].to_f
    chapter.y = params[:y].to_f

    respond_to do |format|
      if chapter.save
        format.html { render nothing: true, notice: 'Update SUCCESSFUL!', status: 200 }
      else
        format.json { render nothing: true, status: 500 }
      end
    end
  end

  def use_item
    adventurer = current_user.adventurers.by_story(params[:story_id]).first
    result = adventurer.use_item(params["item-id"], params[:attribute], params[:modifier])

    if result.present?
      result[:message] = I18n.t('actions.messages.adventurer_update_success')
    else
      result[:message] = I18n.t('actions.messages.adventurer_update_fail')
    end

    respond_to do |format|
      format.json { render json: result.to_json }
    end
  end

  def buy_item
    adventurer = current_user.adventurers.where(story_id: params[:story_id]).first
    modifier_shop = ModifierShop.find(params[:shop_id])
    item = modifier_shop.item
    adventurer_modifier_shop = adventurer.adventurers_shops.where(modifier_shop_id: params[:shop_id]).first

    if adventurer.adventurer_modifier_shop_present? params[:shop_id]
      update_same_adventurer_shop(adventurer, adventurer_modifier_shop, modifier_shop, item)
    else
      create_new_adventurer_shop(adventurer, adventurer_modifier_shop, modifier_shop, item, params[:shop_id])
    end
  end

  def select_weapon
    adventurer = Adventurer.find params[:adventurer_id]
    if adventurer.select_weapon(params[:item_id])
      redirect_to :back, notice: I18n.t('actions.success_weapon_select')
    else
      redirect_to :back, alert: I18n.t('actions.fail_weapon_select')
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
      @chapters = @story.chapters
      @errors = get_errors(@story)
      flash[:alert] = {errors: @errors}
      respond_to do |format|
        case params[:commit]
        when t('actions.edit_items')
          @errors = get_errors(@story)
          
          format.html { render action: :edit_items, controller: :stories, alert: @errors }
          format.json { render json: {errors: @errors.to_json, 
                                      chapters_with_errors: @chapters_with_errors}, 
                                      status: :unprocessable_entity }
        when t('actions.save_story')
          @chapters_with_errors = get_chapters_with_errors(@story)
          format.html { render action: :edit_story, controller: :stories, alert: @errors }
          format.json { render json: {errors: @errors.to_json, 
                                      chapters_with_errors: @chapters_with_errors}, 
                                      status: :unprocessable_entity }
        end
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
      format.html { redirect_to profile_path(current_user) }
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
        when I18n.t('actions.save_story')
          redirect_to story_edit_story_path(story), notice: I18n.t('actions.messages.data_saved')
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
        last_chapter.destroy
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

    def update_same_adventurer_shop(adventurer, adventurer_shop, modifier_shop, item)
      unless adventurer.cant_buy?(adventurer_shop, modifier_shop.price)
        adventurer_shop.quantity -= 1
        if adventurer_shop.save
          adventurer.buy_item(item, modifier_shop)
          redirect_to :back, notice: "Sua compra foi bem sucedida."
        else
          redirect_to :back, alert: "Ocorreu algum problema."
        end
      else
        redirect_to :back, alert: "Não foi possível comprar este ítem."
      end
    end

    def create_new_adventurer_shop(adventurer, adventurer_shop, modifier_shop, item, shop_id)
      unless adventurer.cant_buy?(adventurer_shop, modifier_shop.price)
        adventurer.adventurers_shops.create(modifier_shop_id: shop_id, quantity: modifier_shop.quantity - 1)
        adventurer.buy_new_item(item, modifier_shop.price)
        redirect_to :back, notice: "Sua compra foi bem sucedida."
      else
        redirect_to :back, alert: "Não foi possível comprar este item."
      end
    end

    def set_gold_items_and_attributes(user)
      @adventurer = Adventurer.by_user_and_story(current_user, @story).first
      @adventurer.set_chapter_and_gold(@chapter, @story, params[:reference])
      @adventurer.attribute_and_item_changer(@chapter)
      @adventurers_items = AdventurerItem.by_adventurer(@adventurer)
      @adventurer.chapters << @chapter unless @adventurer.chapters.include? @chapter
    end

    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:resume,
                                    :title,
                                    :prelude,
                                    :initial_gold,
                                    :user_id,
                                    :chapter_numbers,
                                    :cover,
                                    :published,
                                    :chapter_numbers,
                                    items_attributes: [:id, :description, :name, :story_id, :usable, :type, :damage, :attr, :modifier, :_destroy],
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
                                                          modifiers_attributes_attributes: [:id, :attr, :chapter_id, :quantity, :_destroy],
                                                          modifiers_items_attributes: [:id, :chapter_id, :item_id, :quantity, :_destroy, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                                          modifiers_shops_attributes: [:id, :chapter_id, :item_id, :price, :quantity, :_destroy, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                                          items_attributes: [:id, :description, :name, :type, :damage, :story_id, :_destroy]
                                                          ]) if params[:story]
    end
end
