Calabouco::Application.routes.draw do
  root to: "custom_pages#index"

  scope "(:locale)", locales: "/pt-BR|en/" do
    resources :stories, except: :index do
  #    put 'stories/auto_save', as: :auto_save_story_path
      get 'read', to: 'stories#read', as: 'read'
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
      get 'select_weapon'
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


    get 'contato' => 'custom_pages#contact', as: 'contact'
    get 'send' => 'custom_pages#send_message', as: 'send_message'
  end

end
