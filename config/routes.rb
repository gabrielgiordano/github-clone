FILE_NAME_CONSTRAINT = { :file_name => /[\-\_\w\.]+/ }

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
      resources :files, only: [:new, :create]
      get "files/:file_name", to: "files#show", constraints: FILE_NAME_CONSTRAINT, as: :file
      delete "files/:file_name", to: "files#destroy", constraints: FILE_NAME_CONSTRAINT
      resources :teams, only: [:index, :create, :update, :destroy]
      resources :collaborators, only: [:index, :create, :update, :destroy]
      resources :suggestions do
        get "files/:file_name", to: "suggestions#show_file", constraints: FILE_NAME_CONSTRAINT, as: :file
        post "accept", to: "suggestions#accept"
      end
    end
  end
end
