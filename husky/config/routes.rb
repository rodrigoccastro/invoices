Rails.application.routes.draw do
  get "/user/token", to: "user#token"
  get "/user/activate", to: "user#activate"
  get "/user/login", to: "user#login"
  get "/user/logout", to: "user#logout"
  get "/invoice/list", to: "invoice#index"
  get "/invoice/show", to: "invoice#show"
  post "/invoice/create", to: "invoice#create"
  post "/invoice/update", to: "invoice#update"
  delete "/invoice/delete", to: "invoice#delete"

  root "user#index"
end
