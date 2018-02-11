Rails.application.routes.draw do
  root to: 'home#index'

  get 'index_friends', to: 'friend#index'

  post 'friend_request', to: 'friend#friend_request'
  put 'accept_friend_request', to: 'friend#accept_friend_request'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
