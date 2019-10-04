Rails.application.routes.draw do
  get '/:locale' => 'tasks#index'
  root to: 'tasks#index'

  scope "/:locale", locale: /ja|en/ do
    resources :tasks
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
