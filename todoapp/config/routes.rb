Rails.application.routes.draw do
  # TODO: ログイン周りはあとで追加するよ
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  root to: 'tasks#index'
  resources :tasks
end
