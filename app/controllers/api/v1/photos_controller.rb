require_relative '../../../helpers/translation_helper'
include TranslationHelper

require 'aws-sdk-s3'
require 'exifr/jpeg'
require "google/cloud/vision"

class Api::V1::PhotosController < ApplicationController
  before_action :authenticate_user, except: [:index, :show, :destroy]

  def user_photos
    user = User.find_by(firebase_uid: params[:user_id])
    user_photos = user.photos

    user_photos.each do |photo|
      photo.image_url = url_for(photo.image)
    end

    render json: user_photos.to_json(include: { image_attachment: { only: [:id, :service_name, :byte_size] }, image_blob: { only: [:key, :filename, :content_type] }, methods: [:image_url]})
  end

  def index
    firebase_uid = params[:firebase_uid]
    all_users = params[:all_users]

    if all_users == 'true'
      @photos = Photo.all.includes(:user)
    elsif firebase_uid.present?
      user = User.find_by(firebase_uid: firebase_uid)
      @photos = user.present? ? user.photos.includes(:user) : []
    else
      @photos = Photo.all.includes(:user)
    end

    render json: @photos.as_json(include: :user)
  end

  def create
    puts "Request Parameters: #{params.inspect}"
    puts "Received user_id: #{params[:user_id]}"
    puts "Received latitude: #{params[:latitude]}"
    puts "Received longitude: #{params[:longitude]}"
    puts "Received location_enabled: #{params[:location_enabled]}"
    user = User.find_by(firebase_uid: params[:user_id])

    if user.nil?
      return render json: { errors: "User not found" }, status: :not_found
    end

    puts "recieved user: #{user.inspect}"

    uploaded_image = params[:image]

    if uploaded_image.nil?
      return render json: { errors: "No image uploaded" }, status: :unprocessable_entity
    end

    uploaded_image_io = uploaded_image.open
    if uploaded_image.content_type == "image/jpeg"
      exif_data = EXIFR::JPEG.new(uploaded_image_io)
      iso = exif_data.iso_speed_ratings
      shutter_speed = exif_data.shutter_speed_value.to_s
      f_value = exif_data.f_number.to_f
      camera_model = exif_data.model
      taken_at = exif_data.date_time_original
      latitude = exif_data.gps_latitude
      longitude = exif_data.gps_longitude

      # EXIFデータから得られた位置情報をログに出力
      puts "EXIF Latitude: #{exif_data.gps_latitude}"
      puts "EXIF Longitude: #{exif_data.gps_longitude}"
    end

    user_id = user.id

    location_enabled = params[:location_enabled] == "true"

    puts "Latitude: #{latitude}"
    puts "Longitude: #{longitude}"
    puts "Location Enabled: #{location_enabled}"

    vision = Google::Cloud::Vision.image_annotator

    response = vision.label_detection image: params[:image].path
    labels = response.responses.first.label_annotations

    categories = labels.map do |label|
      japanese_name = translate_to_japanese(label.description)
      Category.find_or_create_by(name: label.description, japanese_name: japanese_name)
    end

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

    photo.categories = categories

    uploaded_image_io.rewind
    photo.image.attach(io: uploaded_image_io, filename: uploaded_image.original_filename, content_type: uploaded_image.content_type)

    puts "Photo before save: #{photo.inspect}"

    if photo.save
      image_url = url_for(photo.image)
      render json: { message: 'Image successfully uploaded', url: image_url, status: :created }
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    photo = Photo.find(params[:id])
    render json: photo.as_json(include: :user)
  end

  def update
    photo = Photo.find(params[:id])
    if photo.update(photo_params)
      render json: { message: 'Photo successfully updated', status: :ok }
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    photo = Photo.find(params[:id])
    if photo.destroy
      render json: { message: 'Photo successfully deleted', status: :ok }
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:iso, :shutter_speed, :f_value, :camera_model, :latitude, :longitude, :location_enabled, :taken_at, :image)
  end
end