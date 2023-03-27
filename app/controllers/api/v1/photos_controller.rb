class Api::V1::PhotosController < ApplicationController
  def index
    # 写真一覧を取得する処理
  end

  def create
  user_id = params[:user_id]
  iso = params[:iso]
  shutter_speed = params[:shutter_speed]
  f_value = params[:f_value]
  camera_model = params[:camera_model]
  latitude = params[:latitude]
  longitude = params[:longitude]
  location_enabled = params[:location_enabled]
  taken_at = params[:taken_at]

  photo = Photo.new(
    user_id: user_id,
    iso: iso,
    shutter_speed: shutter_speed,
    f_value: f_value,
    camera_model: camera_model,
    latitude: latitude,
    longitude: longitude,
    location_enabled: location_enabled,
    taken_at: taken_at
  )

  photo.image.attach(params[:image])

  if photo.save
    render json: { message: 'Image successfully uploaded', status: :created }
  else
    render json: { errors: photo.errors.full_messages, status: :unprocessable_entity }
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