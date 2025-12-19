class ApplicationController < ActionController::API
  before_action :authenticate_request
  
  attr_reader :current_user
  
  private
  
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  def require_influencer
    unless @current_user&.influencer?
      render json: { error: 'Access denied. Influencer only.' }, status: :forbidden
    end
  end
  
  def require_subscriber
    unless @current_user&.subscriber?
      render json: { error: 'Access denied. Subscriber only.' }, status: :forbidden
    end
  end
end
