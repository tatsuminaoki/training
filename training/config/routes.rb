Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get 'logins/new'
  post 'logins/login'
  delete 'logins/logout'
end
