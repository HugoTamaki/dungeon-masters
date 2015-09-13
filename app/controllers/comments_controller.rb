class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @story = Story.friendly.find(params[:story_id])
    @comment = @story.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to story_show_path(@story), notice: "Comentário adicionado com sucesso."
    else
      redirect_to story_show_path(@story), alert: "Comentário não foi adicionado com sucesso."
    end
    
  end

  def destroy
    @story = Story.friendly.find(params[:story_id])
    @comment = @story.comments.find(params[:id])
    @comment.destroy
    redirect_to story_show_path(@story), notice: "Comentário excluído."
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :story_id, :content)
    end
end
