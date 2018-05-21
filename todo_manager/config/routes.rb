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
  resources :todos, only: %i(new edit) do
    collection do
      post 'create', to: :create
    end
    member do
      get :detail
      post 'update', to: :update
      post 'destroy', to: :destroy
    end
  end

  get '*not_found', to: 'application#_render_404'
  post '*not_found', to: 'application#_render_404'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
