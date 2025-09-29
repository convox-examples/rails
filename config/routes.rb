Rails.application.routes.draw do
  # Root route - Dashboard
  root 'dashboard#index'
  
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
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Background job monitoring (if using Solid Queue web UI in future)
  # mount SolidQueue::Engine => "/jobs"
end