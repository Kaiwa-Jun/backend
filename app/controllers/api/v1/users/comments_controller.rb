class Api::V1::Users::CommentsController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy]

  def index
    user = User.find_by!(firebase_uid: params[:user_id])
    comments = user.comments.includes(:photo).map do |comment|
      comment.as_json.merge(
        photo: comment.photo.as_json,
        user: comment.user.as_json
      )
    end
    render json: comments
  end
end
