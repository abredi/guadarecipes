Rails.application.routes.draw do
  resources :homes
  resources :orders
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :products

  root to: 'homes#index'
end
