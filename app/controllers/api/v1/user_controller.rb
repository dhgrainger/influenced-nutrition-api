module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authorize_user, only: [:update, :destroy]
      
      # GET /api/v1/users/:id
      def show
        render json: UserSerializer.new(@user).as_json
      end
      
      # PUT/PATCH /api/v1/users/:id
      def update
        if @user.update(user_update_params)
          render json: UserSerializer.new(@user).as_json
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        head :no_content
      end
      
      # DELETE /api/v1/users/:id/disconnect_instagram
      def disconnect_instagram
        if @current_user.id == params[:id].to_i
          @current_user.update(
            provider: nil,
            uid: nil,
            instagram_token: nil,
            instagram_username: nil,
            token_expires_at: nil
          )
          render json: { message: 'Instagram disconnected successfully' }, status: :ok
        else
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
      
      private
      
      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end
      
      def authorize_user
        unless @current_user.id == @user.id
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
      
      def user_update_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end
