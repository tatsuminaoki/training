# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  get 'login', to: 'sessions#new', as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  post 'sessions/create'
  get 'signup', to: 'users#new', as: 'signup'
  post 'users/create', to: 'users#create'
  resources :tasks
end
