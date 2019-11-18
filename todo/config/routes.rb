Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tasks/new'
  post 'tasks/create'
  get 'tasks/edit'
  get 'tasks/show'
  get 'tasks/index'
end