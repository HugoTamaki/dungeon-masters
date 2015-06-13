class ChaptersController < ApplicationController
  respond_to :html, :json

  def show

  end

  def update
    @chapter = Chapter.find(params[:id])
    @story = Story.find(params[:story_id])

    if @chapter.update(chapter_params)
      redirect_to edit_story_path(@story, page: params[:chapter][:page], last_chapter: params[:chapter][:position]), notice: 'Capítulo atualizado com sucesso.'
    else
      redirect_to edit_story_path(@story, page: params[:chapter][:page], last_chapter: params[:chapter][:position]), alert: { :errors => @chapter.errors.full_messages }
    end
  end

  def chapter_params
    params.require(:chapter).permit(:reference, 
                                    :story_id, 
                                    :content, 
                                    :image, 
                                    :x, 
                                    :y, 
                                    :color, 
                                    :image_file_name, 
                                    :image_content_type,
                                    :image_file_size,
                                    :image_updated_at,
                                    decisions_attributes: [:id, :destiny_num, :chapter_id, :item_validator, :_destroy],
                                    monsters_attributes: [:id, :skill, :energy, :name, :chapter_id, :_destroy],
                                    modifiers_attributes_attributes: [:id, :attr, :chapter_id, :quantity, :_destroy],
                                    modifiers_items_attributes: [:id, :chapter_id, :item_id, :quantity, :_destroy, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                    modifiers_shops_attributes: [:id, :chapter_id, :item_id, :price, :quantity, :_destroy, items_attributes: [:id, :description, :name, :story_id, :_destroy]],
                                    items_attributes: [:id, :description, :name, :story_id, :_destroy])
  end
end
