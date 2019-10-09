Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks

  root "tasks#index"

  get "/signup", to: "users#new", as: "signup"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout/:id", to: "sessions#destroy", as: "logout"
  # どこにも当てはまらなかったら404エラーページを返す
  get "*path", to: "application#render_404"
end
