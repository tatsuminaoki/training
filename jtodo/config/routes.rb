Rails.application.routes.draw do
  root 'tasks#index'

  get 'users/new'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :tasks

  namespace :admin do
    resources :users
    get 'users/:id/tasks' => 'users#tasks', as: :user_tasks
  end
end
