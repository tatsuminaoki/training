Rails.application.routes.draw do
  root to: 'task#index'
  get 'task/index'
  get 'task/show'
  get 'task/new'
  post 'task/create'
  get 'task/edit'
  get 'task/update'
  post 'task/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
