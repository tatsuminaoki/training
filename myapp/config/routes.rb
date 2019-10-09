Rails.application.routes.draw do
  root to: 'tasks#index'
  get 'tasks/index'
  get 'tasks/new'
  get 'tasks/:id', to: 'tasks#show', as: 'tasks'
  post 'tasks/create'
  get 'tasks/:id/edit', to: 'tasks#edit', as: 'tasks_edit'
  get 'tasks/update'
  post 'tasks/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
