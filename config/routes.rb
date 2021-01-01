Rails.application.routes.draw do
  resources :charges, only: [] do
    member do
      get 'success'
      get 'cancel'
    end
  end

  resources :homes
  resources :orders
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :products

  root to: 'homes#index'
end
