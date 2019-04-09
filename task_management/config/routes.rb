Rails.application.routes.draw do
  root 'tasks#list'
  get 'new_task' => 'tasks#new_task' , as: 'new_task'
  get 'detail_task/:task_id' => 'tasks#detail_task', as: 'detail_task'
  get 'edit_task/:task_id' => 'tasks#edit_task', as: 'edit_task'
  delete 'destroy_task/:id' => 'tasks#destroy', as: 'destroy_task'
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
