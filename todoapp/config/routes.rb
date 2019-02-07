Rails.application.routes.draw do
  namespace :admin do
    root to: 'users#index'
    resources :users
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'tasks#index'
  resources :tasks

  get '*path', controller: 'application', action: 'render_404'
end
