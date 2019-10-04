# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'

  resources :tasks

  resources :users

  resources :sessions
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get '*path', controller: 'application', action: 'render_404'
  post '*path', controller: 'application', action: 'render_404'
end
