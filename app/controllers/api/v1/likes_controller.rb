class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user, only: [:show, :create, :destroy]
  before_action :set_photo, only: [:show, :destroy]
  before_action :set_like, only: [:show, :destroy]

  def show
    likes_count = @photo.likes.size
    if @like
      render json: @like.attributes.merge({ liked: true, likes_count: likes_count })
    else
      render json: { liked: false, likes_count: likes_count }, status: :ok
    end
  end


  def create
    photo = Photo.find(params[:photo_id])
    like = photo.likes.find_or_initialize_by(user: current_user)
    if like.new_record?
      if like.save
        render json: like, status: :created
      else
        render json: like.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Like already exists' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @like
      if @like.destroy
        render json: { success: true }, status: :ok
      else
        render json: { success: false, message: "Failed to delete like" }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: "Like not found" }, status: :not_found
    end
  end

  private

  def set_photo
    @photo = Photo.includes(:likes).find(params[:photo_id])
  end

  def set_like
    @like = @photo.likes.find_by(user_id: @current_user.id)
  end
end