# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, only: %i[new create show edit update destroy]
  get 'languages', to: 'languages#index'
end
