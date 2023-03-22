module Api
  module V1
    class HelloController < ApplicationController
      def index
        render json: { message: 'Hello from Rails API!' }
      end
    end
  end
end