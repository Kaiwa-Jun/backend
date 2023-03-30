module Api
  module V1
    class Api::V1::UsersController < ApplicationController
      def create
        @user = User.new(user_params)
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
    end
  end
end
