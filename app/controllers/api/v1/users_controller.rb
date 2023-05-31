require 'firebase_id_token'
module Api
  module V1
    class Api::V1::UsersController < ApplicationController
      before_action :authenticate

      def create
        @user = User.new(user_params)
        @user.provider = 'firebase'
        if @user.save
          render json: @user, status: :created
        else
          # バリデーションエラーをログに出力
          Rails.logger.debug @user.errors.inspect
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:firebase_uid, :display_name, :email, :avatar_url)
      end

      def authenticate
  id_token = params[:user][:idToken]

  begin
    FirebaseIdToken::Certificates.request
    certificates = FirebaseIdToken::Certificates.current
    Rails.logger.debug "Certificates: #{certificates.inspect}"
  rescue => e
    Rails.logger.debug "Certificates request failed with error: #{e.inspect}"
  end

  begin
    @decoded_token = FirebaseIdToken::Signature.verify(id_token)
  rescue => e
    Rails.logger.debug "Token verification failed with error: #{e.inspect}"
  end

  Rails.logger.debug "Decoded token: #{@decoded_token.inspect}"

  unless @decoded_token
    render json: { message: '認証に失敗しました' }, status: :unauthorized
  end
end

    end
  end
end
