Rails.application.routes.draw do
  resource :tasks
  root 'tasks#index'
  get 'tasks/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
