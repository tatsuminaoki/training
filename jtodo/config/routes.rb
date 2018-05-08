Rails.application.routes.draw do
  root 'tasks#index'

  get 'users/new'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :tasks, :users

  namespace :admin do
    root 'users#index'
    resources :users
    get 'users/:id/tasks' => 'users#tasks', as: :user_tasks
  end

  get '*path', controller: 'application', action: 'render_404'

end