Rails.application.routes.draw do
  get 'labels/index'
  get 'labels/new'
  get 'labels/create'
  get 'labels/edit'
  get 'labels/update'
  get 'labels/destroy'
  root 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks
  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]

  get '*path', controller: 'application', action: 'render_404'
end
