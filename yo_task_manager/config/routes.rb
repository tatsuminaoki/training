Rails.application.routes.draw do
  get 'task/index'
  get 'task/new'
  get 'task/create'
  get 'task/show'
  get 'task/edit'
  get 'task/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
