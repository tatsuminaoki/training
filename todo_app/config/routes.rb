Rails.application.routes.draw do
  root 'tasks#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :tasks
  get 'tasks/index'
  get 'labels' => 'labels#index'
end
