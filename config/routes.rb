  Calabouco::Application.routes.draw do

  resources :stories, except: :index do
#    put 'stories/auto_save', as: :auto_save_story_path
    get 'read', on: :collection
#    put 'auto_save', on: :collection
    get 'prelude'
    put 'update_tabs'
    get 'graph_json'
    get 'graph_json_show', on: :collection
    post 'node_update'
    get 'erase_image', as: 'erase_image'
    get 'edit_special_attributes', as: "edit_special_attributes"
    get 'edit_story', to: 'stories#edit_story', as: 'edit_story'
    get 'edit_items', as: "edit_items"
    get 'graph'
    post 'use_item', on: :collection
    get 'buy_item'
    post 'publish'
    get 'search_result', as: 'search_result', on: :collection
    get 'detail', as: 'show'
    get 'update_chapter_number', as: 'update_chapter_number'
    resources :comments
    put :favorite, on: :member
    resources :chapters do
      put ':id', to: 'chapters#update', as: 'chapter_update', on: :collection
    end
  end

  resources :adventurers do
    put 'update_adventurer_status', on: :collection
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  get 'profile/:id' => 'users#profile', as: 'profile'

  root to: "custom_pages#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
