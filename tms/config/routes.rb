Rails.application.routes.draw do
  get 'admin/index'

  namespace 'admin' do
    resources :users
  end

  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  resources :task_labels
  resources :labels
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root setting
  root to: 'tasks#index'
end
