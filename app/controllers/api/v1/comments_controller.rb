class Api::V1::CommentsController < ApplicationController

  def index
    photo = Photo.find(params[:photo_id])
    comments = photo.comments
    render json: comments
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show
    comment = Comment.find(params[:id])
    render json: comment
  end

  private

  def comment_params
    params.require(:comment).permit(:photo_id, :content)
  end
end
