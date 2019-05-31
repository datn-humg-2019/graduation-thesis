require "api_constraints"
namespace :api, defaults: {format: "json"} do
  post "/login", to: "sessions#create"
  post "/signup", to: "users#create"
  post "/create_account", to: "users#create_account"
  post "/user-info", to: "users#show"
  post "/forgot-password", to: "users#forgot_password"
  post "/change-pass", to: "users#change_pass"
  post "/inventorys", to: "product_warehouses#inventory"
  post "/list_sales_count", to: "bills#list_sales_count"
  post "/list_sales_price", to: "bills#list_sales_price"
  post "/list_buys_count", to: "histories#list_buys_count"
  post "/list_buys_price", to: "histories#list_buys_price"
  post "/admin_chart_sales", to: "charts#admin_chart_sales"
  post "/admin_chart_buys", to: "charts#admin_chart_buys"
  resources :users, only: [:index]
  resources :categories, only: [:index, :create]
  resources :products, only: [:index, :create]
end
