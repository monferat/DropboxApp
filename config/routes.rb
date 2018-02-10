Rails.application.routes.draw do
  root to: 'home#index'

  post 'friend_request', to: 'home#friend_request'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
