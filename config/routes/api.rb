require "api_constraints"
namespace :api, defaults: {format: "json"} do
  post "/login", to: "sessions#create"
  post "/signup", to: "users#create"
  post "/create_account", to: "users#create_account"
  post "/user-info", to: "users#show"
  post "/forgot-password", to: "users#forgot_password"
  resources :users, only: [:index]
  resources :categories, only: [:index, :create]
  resources :products, only: [:index, :create]
end
