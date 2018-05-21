Rails.application.routes.draw do
  resources :admin do
    member do
      get :todos
      post :todos
      get 'new', to: 'admin#new_todos'
      post 'create', to: 'admin#create_todos'
    end
  end

  get 'login', to: 'users#login'
  post 'login', to: 'users#login_post'
  post 'logout', to: 'users#logout'
  get 'signup', to: 'users#new'
  post 'users/create'

  root 'todos#index'
  post '/', to: 'todos#index'
  get 'todos/new'
  post 'todos/create'
  get 'todos/:id/detail', to: 'todos#detail'
  get 'todos/:id/edit', to: 'todos#edit'
  post 'todos/:id/update', to: 'todos#update'
  post 'todos/:id/destroy', to: 'todos#destroy'
  get '*not_found', to: 'application#_render_404'
  post '*not_found', to: 'application#_render_404'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
