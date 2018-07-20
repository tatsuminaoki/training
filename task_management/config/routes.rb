Rails.application.routes.draw do
  root to: 'tasks#index'
  get 'tasks/index'
  get 'tasks/show/:id', to: 'tasks#show', as: 'show_task'
  get 'tasks/edit/:id', to: 'tasks#edit', as: 'edit_task'
  get 'tasks/new'
  post 'tasks/create', as:'tasks'
  patch 'tasks/edit/:id', to: 'tasks#update'
  get 'tasks/delete/:id', to: 'tasks#destroy', as: 'delete_task'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#login'
  delete 'logout', to: 'sessions#logout'

  get 'admin', to: 'admins#index'
  get 'admin/show/:id', to: 'admins#show', as: 'admins_show'
  get 'admin/edit/:id', to: 'admins#edit', as: 'admins_edit'
  get 'admin/new', to:'admins#new', as: 'admins_new'
  patch 'admin/edit/:id', to: 'admins#update'
  post 'admin/create', to: 'admins#create', as: 'admins'
  get 'admin/delete/:id', to: 'admins#destroy', as: 'admins_delete'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
