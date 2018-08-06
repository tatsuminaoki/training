# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  root 'tasks#index'
  resources :tasks, except: %i[index]
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create]
end
