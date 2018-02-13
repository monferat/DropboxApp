Rails.application.routes.draw do
  root to: 'home#index'

  get 'index_friends', to: 'friends#index'

  get 'index_dropbox', to: 'dropbox#index'

  get 'dropbox/auth' => 'dropbox#auth'
  get 'dropbox/auth_callback' => 'dropbox#auth_callback'

  post 'friend_request', to: 'friends#friend_request'
  put 'accept_friend_request', to: 'friends#accept_friend_request'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'

  }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
