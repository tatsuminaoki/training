Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks
  root to: 'tasks#index'
  get '*anything' => 'errors#routing_error' 
end
