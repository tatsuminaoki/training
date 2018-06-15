Rails.application.routes.draw do
  root to: 'tasks#index'
  get 'tasks/index'
  get 'tasks/show/:id', to: 'tasks#show'
  get 'tasks/edit/:id', to: 'tasks#edit'
  get 'tasks/new'
  
  post 'tasks/create', as:"tasks"
  patch 'tasks/edit/:id', to: 'tasks#update'
  get 'tasks/delete/:id', to: 'tasks#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
