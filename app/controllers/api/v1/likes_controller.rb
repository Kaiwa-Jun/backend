class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user
  before_action :set_photo, only: [:create, :destroy]

  def index
    @likes = current_user.likes
    render json: @likes
  end

  def create
    @like = @photo.likes.build(user_id: current_user.id)
    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @photo.likes.find_by(user_id: current_user.id)
    @like.destroy
    head :no_content
  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id])
  end
end
