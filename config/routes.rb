# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create]
  resources :user_credentials, only: %i[new create]
  namespace :admin do
    resources :users
  end
  resources :labels

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
