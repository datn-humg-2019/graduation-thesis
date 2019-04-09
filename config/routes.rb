Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    get "home/index"
    post "destroy_image", to: "images#destroy", as: "destroy_image"

    namespace :admin do
      resources :users
      resources :categories
      resources :products
      get "/", to: "dashboards#index"
    end

    devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions",
      passwords: "users/passwords"}
  end
end
