Rails.application.routes.draw do
  resources :list

  get '/', to: 'list#index'
  get '*path', controller: 'application', action: 'error_404'
end
