Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'

  resources :tasks

  get '*path', controller: 'application', action: 'render_404'
  post '*path', controller: 'application', action: 'render_404'
end
