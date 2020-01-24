# frozen_string_literal: true

Rails.application.routes.draw do
  resource :sessions, only: %i[new create destroy]

  match '/sign_in', to: 'sessions#new', via: 'get'
  match '/sign_out', to: 'sessions#destroy', via: 'delete'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :tasks

  root 'tasks#index'
end
