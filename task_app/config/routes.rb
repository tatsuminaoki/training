Rails.application.routes.draw do
  root to: 'tasks#index'

  controller :tasks do
    resources :tasks, except: [:index, :show]
  end
end
