Rails.application.routes.draw do

  get 'sessions/new'
  root 'tasks#index'
  resources :tasks

end
