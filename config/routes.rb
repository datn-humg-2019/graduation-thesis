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
    get "list_product", to: "products#list_product", as: "list_product"
    get "show_product", to: "products#show_product", as: "show_product"
    get "product", to: "products#show_product_public", as: "show_product_public"
    get "change_pass", to: "change_pass#index", as: "change_pass"
    post "change_password", to: "change_pass#update", as: "change_password"
    post "destroy_image", to: "images#destroy", as: "destroy_image"
    post "create_product_warehouses", to: "product_warehouses#create", as: "create_product_warehouses"

    get "export_template", to: "import_export#export_template", as: "export_template"
    post "import_pw", to: "import_export#import_pw", as: "import_pw"
    get "select_from_user", to: "bills#select_from_user", as: "select_from_user"
    get "update_confirmed", to: "bills#update_confirmed", as: "update_confirmed"

    get "bill_pdf", to: "pdfs#bill_pdf", as: "bill_pdf"
    get "sell_pdf", to: "pdfs#sell_pdf", as: "sell_pdf"
    get "sell_gtgt", to: "pdfs#sell_gtgt", as: "sell_gtgt"

    post "list_io", to: "home#chart_io", as: "list_io"
    post "list_p_io", to: "home#chart_p_io", as: "list_p_io"

    get "inventories", to: "warehouses#inventories", as: "inventories"

    resources :products
    resources :bills
    resources :histories
    resources :sells
    resources :warehouses do
      resources :product_warehouses
    end

    namespace :admin do
      resources :users
      resources :categories
      resources :products
      get "/", to: "dashboards#index"
      get "count_user", to: "dashboards#count_user", as: "count_user"
    end

    devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions",
      passwords: "users/passwords"}
  end
end
