Rails.application.routes.draw do
  resources :tasks
  get '/', to: 'tasks#index'
end
