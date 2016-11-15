Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  devise_for :users

  resources :teams do
    resources :members, controller: "team_members", only: [:create]
    delete "members/:user_id", to: "team_members#destroy", as: :member
  end

  resources :projects do
    resources :collaborators, controller: "project_collaborators", only: [:index, :create, :update, :destroy]
  end
end
