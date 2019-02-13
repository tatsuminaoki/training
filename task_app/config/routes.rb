# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks, except: %i[show]
end
