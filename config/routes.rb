Rails.application.routes.draw do
  root to: 'home#index'

  get 'main_list', to: 'home#main_list'
  get 'friends_list', to: 'home#friends_list'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
