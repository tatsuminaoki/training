Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, except: %i(index)
end
