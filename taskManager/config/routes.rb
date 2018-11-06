Rails.application.routes.draw do
  resources :list
  resources :login

  namespace :admin do
    resources :users
  end

  get '/', to: 'list#index'
  get '/admin', to: 'admin/users#index'
  get '/logout', to: 'login#logout'
  post '/logout', to: 'login#logout'
  get '*path', controller: 'application', action: 'error_404'
  post '*path', controller: 'application', action: 'error_404'
end
