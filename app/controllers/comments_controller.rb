class CommentsController < ApplicationController
  def create
    @story = Story.find(params[:story_id])
    @comment = @story.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to story_prelude_path(@story, new_story: true), notice: "Comentário adicionado com sucesso."
    else
      redirect_to story_prelude_path(@story, new_story: true), alert: "Comentário não foi adicionado com sucesso."
    end
    
  end

  def destroy
    @story = Story.find(params[:story_id])
    @comment = @story.comments.find(params[:id])
    @comment.destroy
    redirect_to story_prelude_path(@story, new_story: true), notice: "Comentário excluído."
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :story_id, :content)
    end
end
