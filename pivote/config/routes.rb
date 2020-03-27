Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users do
      get 'tasks'
    end
  end

  root to: 'tasks#index'
  resources :tasks
end
