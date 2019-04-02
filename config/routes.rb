Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "home/index"
    root "home#index"
    devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions",
      passwords: "users/passwords"}
  end
end
