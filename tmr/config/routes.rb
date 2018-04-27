Rails.application.routes.draw do
  get '/login', to: 'logins#index'
  post '/login', to: 'logins#login'
  get '/logout', to: 'logins#logout'

  get '/users/:id/tasks', to: 'users#tasks'

  resources :tasks
  resources :users

  root 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
