# frozen_string_literal: true

Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  post 'users/create', to: 'users#create'
  get 'tasks/new'
  post 'tasks/create'
  get 'tasks/:id', to: 'tasks#show', as: 'tasks_show'
  get 'tasks/:id/edit', to: 'tasks#edit', as: 'tasks_edit'
  patch 'tasks/:id', to: 'tasks#update', as: 'tasks_update'
  get 'tasks/', to: 'tasks#index'
  delete 'task/:id', to: 'tasks#destroy', as: 'tasks_destroy'
end
