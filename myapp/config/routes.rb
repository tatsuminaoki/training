Rails.application.routes.draw do
  resources :tasks
  resources :users
  root to: 'tasks#index'

  get    'login', to: 'sessions#new'
  post   'login', to: 'sessions#create'
  delete 'login', to: 'sessions#destroy'
  get    'signup', to: 'users#new'

  namespace :admin do
    resources :users
  end
end
