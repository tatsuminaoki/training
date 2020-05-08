Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks do
    get :sort, on: :collection
  end
  root to: 'tasks#index'
  get '*path', to: 'application#rescue404' 
end
