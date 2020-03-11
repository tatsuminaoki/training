Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ja/ do
    root 'projects#index'
    resources :projects
    resources :tasks
  end

  get '*path', to: 'application#routing_error', via: :all
end
