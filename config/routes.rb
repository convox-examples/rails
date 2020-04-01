Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # basic health check
  get "/health", to: proc { [ 200, {}, [''] ] }

  get "/test", to: proc { [ 200, {}, ["Hello World!"] ] }

end
