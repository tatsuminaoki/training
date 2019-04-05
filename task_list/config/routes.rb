Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :edit, :update, :show]
  resources :labels, only:[:new, :create, :destroy, :index]
  namespace :admin do
    resources :users, only: [:index, :show, :destroy, :edit, :update]
  end
  resources :maintenances, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
