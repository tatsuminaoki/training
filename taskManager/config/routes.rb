Rails.application.routes.draw do
  get '/', to: 'list#index'
  get 'list/entry'
  get 'list/edit/:id', to: 'list#edit', as: 'list_edit'
  get 'list/delete/:id', to: 'list#delete', as: 'list_delete'
  patch 'list/update/:id', to: 'list#update', as: 'list_update'
  post 'list/insert'
end
