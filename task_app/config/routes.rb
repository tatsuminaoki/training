# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'

  controller :tasks do
    resources :tasks, except: %i[index show]
  end

  get '*path', controller: 'application', action: 'render_404'
end
