Rails.application.routes.draw do
  get '/', to: 'list#index'
  get 'list/entry'
  get 'list/edit/:id', to: 'list#edit'
  get 'list/delete/:id', to: 'list#delete'
  patch 'list/update/:id', to: 'list#update'
  post 'list/insert'
end
