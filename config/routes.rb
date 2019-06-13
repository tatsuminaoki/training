# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: %i[new create]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
