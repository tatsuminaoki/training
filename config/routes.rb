Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, only: %i[new create show edit update destroy]
end
