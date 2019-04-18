class ActionDispatch::Routing::Mapper
  def draw routes_name
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  draw :api
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    get "home/index"
    get "list_tag", to: "products#list_tag", as: "list_tag"
    post "destroy_image", to: "images#destroy", as: "destroy_image"

    resources :warehouses

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
