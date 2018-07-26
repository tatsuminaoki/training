# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, except: %i[index]
  resources :sessions, only: %i[new create destroy]
end
