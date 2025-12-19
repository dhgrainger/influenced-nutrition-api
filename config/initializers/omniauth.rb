# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram_graph, 
    ENV['INSTAGRAM_APP_ID'], 
    ENV['INSTAGRAM_APP_SECRET'],
    scope: 'user_profile,user_media',
    exchange_long_lived_token: true # Get 60-day token instead of 1-hour
end

# Set OmniAuth logger
OmniAuth.config.logger = Rails.logger

# Handle CSRF
OmniAuth.config.allowed_request_methods = [:post, :get]
