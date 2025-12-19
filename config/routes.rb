Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/signup', to: 'auth#signup'
      post 'auth/login', to: 'auth#login'
      get 'auth/me', to: 'auth#me'
      
      # OmniAuth callback routes
      get 'auth/:provider/callback', to: 'omniauth_callbacks#instagram_graph'
      post 'auth/:provider/callback', to: 'omniauth_callbacks#instagram_graph'
      get 'auth/failure', to: 'omniauth_callbacks#failure'
      
      # User routes
      resources :users, only: [:show, :update, :destroy] do
        member do
          delete 'disconnect_instagram', to: 'users#disconnect_instagram'
        end
      end
      
      # Health check
      get 'health', to: proc { [200, {}, ['OK']] }
    end
  end
  
  # OmniAuth routes (handled by middleware)
  get '/auth/:provider', to: 'api/v1/omniauth_callbacks#passthru', as: :omniauth_authorize
  
  # Root path
  root to: proc { [200, {}, ['Influenced Nutrition API v1.0']] }
end
