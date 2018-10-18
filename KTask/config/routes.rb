# frozen_string_literal: true

Rails.application.routes.draw do
  get 'admin' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get 'index' => 'tasks#index'
  resources :tasks

  root 'sessions#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
