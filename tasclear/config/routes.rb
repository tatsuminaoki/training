# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, except: %i[index]
  get 'sort', to: 'tasks#sort_deadline'
end
