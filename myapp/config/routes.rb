# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'

  resources :tasks

  resources :users

  get '*path', controller: 'application', action: 'render_404'
  post '*path', controller: 'application', action: 'render_404'
end
