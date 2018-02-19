Rails.application.routes.draw do

  resources :dropbox_files, only: [:new, :create, :destroy]

  root to: 'home#index'

  get 'index_friends', to: 'friends#index'

  get 'index_dropbox', to: 'dropbox#index'
  get 'dropbox_files_list', to: 'dropbox#files_list'
  get 'dropbox/download_client_file', as: :download_client_file
  get 'dropbox/share_file_link', as: :share_file_link

  get 'dropbox/auth' => 'dropbox#auth'
  get 'dropbox/auth_callback' => 'dropbox#auth_callback'

  post 'friend_request', to: 'friends#friend_request'
  put 'accept_friend_request', to: 'friends#accept_friend_request'

  get 'share_file', to: 'dropbox#share_file'
  get 'show', to: 'friends#show'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'

  }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
