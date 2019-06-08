require "api_constraints"
namespace :api, defaults: {format: "json"} do
  # api for authencation
  post "/login", to: "sessions#create"
  post "/signup", to: "users#create"
  post "/create_account", to: "users#create_account"
  post "/user-info", to: "users#show"
  post "/forgot-password", to: "users#forgot_password"
  post "/change-pass", to: "users#change_pass"

  #api for admin
  post "/inventorys", to: "product_warehouses#inventory"

  post "/list_sales_count", to: "bills#list_sales_count"
  post "/list_sales_price", to: "bills#list_sales_price"
  post "/bills", to: "bills#bills_user"
  post "/bill_detail", to: "bills#bill_detail"

  post "/list_buys_count", to: "histories#list_buys_count"
  post "/list_buys_price", to: "histories#list_buys_price"

  post "/admin_chart_sales", to: "charts#admin_chart_sales"
  post "/admin_chart_buys", to: "charts#admin_chart_buys"

  #api for user
  post "/warehouses", to: "warehouses#index"
  post "/list_categories", to: "warehouses#list_categories"
  post "/user_inventory", to: "warehouses#user_inventory"
  post "/user_stop_providing", to: "warehouses#user_stop_providing"
  post "/user_start_providing", to: "warehouses#user_start_providing"
  post "/user_stop_providing_category", to: "warehouses#user_stop_providing_category"
  post "/user_start_providing_category", to: "warehouses#user_start_providing_category"

  post "/create_product_warehouse", to: "user_apis#create_product_warehouse"

  post "/sells", to: "sells#index"
  post "/sell", to: "sells#sell_product"
  post "/sell_detail", to: "sells#sell_detail"

  resources :users, only: [:index]
  resources :categories, only: [:index, :create]
  resources :products, only: [:index, :create]
end
