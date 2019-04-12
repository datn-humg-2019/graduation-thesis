require "api_constraints"
namespace :api, defaults: {format: "json"} do
  post "/login", to: "sessions#create"
  post "/signup", to: "users#create"
end
