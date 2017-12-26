Rails.application.routes.draw do
  resources :labels
  root to: 'tasks#index'
  resources :tasks
  namespace :admin do
    resources :users
  end

  get 'logins/new'
  post 'logins/login'
  delete 'logins/logout'

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
