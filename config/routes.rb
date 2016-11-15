Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  devise_for :users

  resources :projects do
    resources :collaborators, only: [:index, :create, :update, :destroy]
  end
end
