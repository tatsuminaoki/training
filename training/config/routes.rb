Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  namespace :admin do
    resources :users
  end

  get 'logins/new'
  post 'logins/create'
  delete 'logins/destroy'
end
