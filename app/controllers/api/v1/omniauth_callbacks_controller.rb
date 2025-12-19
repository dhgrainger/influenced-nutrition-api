# app/controllers/api/v1/omniauth_callbacks_controller.rb
module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      skip_before_action :authenticate_request
      
      # GET/POST /auth/instagram_graph/callback
      def instagram_graph
        auth = request.env['omniauth.auth']
        
        user = User.from_omniauth(auth)
        
        if user.persisted?
          # Update token if user already exists
          user.update(
            instagram_token: auth.credentials.token,
            token_expires_at: Time.at(auth.credentials.expires_at),
            instagram_username: auth.info.nickname
          )
          
          token = JsonWebToken.encode(user_id: user.id)
          
          # For API: return JSON
          if request.format.json?
            render json: { 
              token: token, 
              user: UserSerializer.new(user).as_json,
              message: 'Successfully authenticated with Instagram'
            }, status: :ok
          else
            # For web: redirect to frontend with token
            redirect_to "#{ENV['FRONTEND_URL']}/auth/callback?token=#{token}"
          end
        else
          error_message = user.errors.full_messages.join(', ')
          
          if request.format.json?
            render json: { error: error_message }, status: :unprocessable_entity
          else
            redirect_to "#{ENV['FRONTEND_URL']}/auth/failure?error=#{CGI.escape(error_message)}"
          end
        end
      end
      
      # GET/POST /auth/failure
      def failure
        error = params[:message] || 'Authentication failed'
        
        if request.format.json?
          render json: { error: error }, status: :unauthorized
        else
          redirect_to "#{ENV['FRONTEND_URL']}/auth/failure?error=#{CGI.escape(error)}"
        end
      end
    end
  end
end