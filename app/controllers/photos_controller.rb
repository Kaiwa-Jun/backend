class PhotosController < ApplicationController
  # createアクションを追加
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # userはcurrent_userを使う
  def create
    @photo = current_user.photos.build(photo_params)

    #jsonで返す
    if @photo.save
      render json: @photo, status: :created
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:file_url, :iso, :shutter_speed, :f_value, :camera_model, :latitude, :longitude, :location_enabled, :taken_at)
  end
end
