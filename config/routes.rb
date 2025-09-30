Rails.application.routes.draw do
  # Root route - Simple home page that doesn't use asset pipeline
  root 'home#index'
  
  # Health check endpoint
  get 'health', to: 'dashboard#health'
  
  # User management
  resources :users
  
  # API endpoints
  namespace :api do
    get 'status', to: 'status#show'
    get 'stats', to: 'status#stats'
    
    resources :users, only: [:index, :show, :create, :update, :destroy]
  end
  
  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end