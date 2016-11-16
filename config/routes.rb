Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  devise_for :users

  resources :teams do
    scope module: :teams do
      resources :members, only: [:create]
      delete "members/:user_id", to: "members#destroy", as: :member
    end
  end

  resources :projects do
    scope module: :projects do
      resources :teams, only: [:index, :create, :update, :destroy]
      resources :collaborators, only: [:index, :create, :update, :destroy]
    end
  end
end
