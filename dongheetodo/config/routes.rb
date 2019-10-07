Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks
  resources :users
  
  root "tasks#index"
  # どこにも当てはまらなかったら404エラーページを返す
  get "*path", to: "application#render_404"
end
