Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  get   'login'  => 'user#login_top'
  post  'login'  => 'user#login'
  get   'logout' => 'user#logout'

  get  'admin' => 'admin#index'
  get  'admin/users' => 'admin#users'
  get  'admin/api/user/all' => 'admin#all_users'
  post 'admin/api/user' => 'admin#add_user'
  delete 'admin/api/user/:id' => 'admin#delete_user'

  get  'board' => 'board#index'
  get  'board/' => 'board#index'
  get  'board/api/master/all' => 'board#get_master'
  get  'board/api/task/all' => 'board#get_all_task'
  get  'board/api/task/:id' => 'board#get_task_by_id', constraints: { id: /\d+/ }
  get  'board/api/task/search' => 'board#get_task_by_conditions'
  post 'board/api/task' => 'board#create'
  delete 'board/api/task/:id' => 'board#delete'
  put 'board/api/task/:id' => 'board#update'

  get  'maintenance/' => 'maintenance#index'
  get  'maintenance/api/state' => 'maintenance#maintenance?'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
