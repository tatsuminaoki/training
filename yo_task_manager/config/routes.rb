# frozen_string_literal: true

Rails.application.routes.draw do
  get '/:locale', constraints: { locale: I18n.available_locales.map(&:to_s) }, to: 'tasks#index'
  root to: 'tasks#index'

  scope '/:locale', locale: /ja|en/ do
    resources :tasks
    resources :sessions, only: [:new, :create, :destroy]

    get 'login', to: 'sessions#new', as: 'login'
    get 'sessions', to: 'sessions#new'
    get 'logout', to: 'sessions#destroy', as: 'logout'
  end

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
