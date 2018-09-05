class CommentsController < ApplicationController
  before_action :set_params, only: [:show, :destroy]

  def create
    @comment = Comment.create(comment_params)
    if @comment.valid?
      redirect_to comments_path
    else
      render :index
    end
  end

  def destroy
    @comment.destroy
    redirect_to topic_path(@cocktail.topic_id)
  end

  private

  def set_params
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:title, :user)
  end
end
