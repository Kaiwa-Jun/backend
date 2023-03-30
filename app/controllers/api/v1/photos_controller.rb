require 'exifr/jpeg'
class Api::V1::PhotosController < ApplicationController

  def index
    # 写真一覧を取得する処理
  end

  def create
    puts "Request Parameters: #{params.inspect}"
    puts "Received user_id: #{params[:user_id]}"
    user = User.find_by(firebase_uid: params[:user_id])
    puts "recieved user: #{user.inspect}"

    uploaded_image = params[:image]
    exif_data = EXIFR::JPEG.new(uploaded_image.tempfile)

    user_id = user.id # この行を修正
    # 以降のコードは変更なし
    iso = exif_data.iso_speed_ratings
    shutter_speed = exif_data.shutter_speed_value.to_s
    f_value = exif_data.f_number.to_f
    camera_model = exif_data.model
    latitude = exif_data.gps_latitude.present? ? exif_data.gps_latitude[0] + exif_data.gps_latitude[1]/60 + exif_data.gps_latitude[2]/3600 : nil
    longitude = exif_data.gps_longitude.present? ? exif_data.gps_longitude[0] + exif_data.gps_longitude[1]/60 + exif_data.gps_longitude[2]/3600 : nil
    location_enabled = exif_data.gps_latitude.present? && exif_data.gps_longitude.present?
    taken_at = exif_data.date_time_original

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

    puts "Photo before save: #{photo.inspect}"

    if photo.save
      puts "Photo after save: #{photo.inspect}"
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