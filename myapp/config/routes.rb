Rails.application.routes.draw do
  root to: 'task#index'
  get 'task/index'
  get 'task/new'
  get 'task/:id', to: 'task#show', as: 'task'
  post 'task/create'
  get 'task/:id/edit', to: 'task#edit', as: 'task_edit'
  get 'task/update'
  post 'task/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
