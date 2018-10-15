Rails.application.routes.draw do
  resources :list

  get '/', to: 'list#index'
end
