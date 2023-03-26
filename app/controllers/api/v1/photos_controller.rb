class Api::V1::PhotosController < ApplicationController
  def index
    # 写真一覧を取得する処理
  end

  def create
    user_id = params[:user_id]
    file_url = params[:file_url]
    iso = params[:iso]
    shutter_speed = params[:shutter_speed]
    f_value = params[:f_value]
    camera_model = params[:camera_model]
    latitude = params[:latitude]
    longitude = params[:longitude]
    location_enabled = params[:location_enabled]
    taken_at = params[:taken_at]

    photo = Photo.create(
      user_id: user_id,
      file_url: file_url,
      iso: iso,
      shutter_speed: shutter_speed,
      f_value: f_value,
      camera_model: camera_model,
      latitude: latitude,
      longitude: longitude,
      location_enabled: location_enabled,
      taken_at: taken_at
    )

    if photo.persisted?
      render json: { status: :created }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def show
    # 特定の写真を取得する処理
  end

  def update
    # 特定の写真を更新する処理
  end

  def destroy
    # 特定の写真を削除する処理
  end
end