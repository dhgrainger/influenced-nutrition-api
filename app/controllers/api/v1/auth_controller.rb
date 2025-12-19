module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:login, :signup]
      
      # POST /api/v1/auth/signup
      def signup
        user = User.new(user_params)
        
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { 
            token: token, 
            user: UserSerializer.new(user).as_json
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email]&.downcase)
        
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { 
            token: token, 
            user: UserSerializer.new(user).as_json
          }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
      
      # GET /api/v1/auth/me
      def me
        render json: UserSerializer.new(@current_user).as_json
      end
      
      private
      
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :name, :user_type)
      end
    end
  end
end
