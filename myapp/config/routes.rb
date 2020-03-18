Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ja/ do
    root 'projects#index'
    resources :projects
    resources :tasks
    resources :search, only: [:index]
  end

  get '*path', to: 'application#routing_error', via: :all
end
