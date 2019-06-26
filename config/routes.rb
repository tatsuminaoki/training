Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :tasks

  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'
  root 'tasks#index'
end
