Rails.application.routes.draw do
  get '/login', to: 'logins#index'
  post '/login', to: 'logins#login'
  get '/logout', to: 'logins#logout'
  get '/signup', to: 'logins#signup'
  post '/register', to: 'logins#register'

  get '/users/:id/tasks', to: 'users#tasks'

  resources :tasks

  scope :admin do
    resources :users
    resources :tasks
    get '/' => redirect('/admin/users')
    get '/users/:id/tasks', to: 'users#tasks'
  end

  root 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
