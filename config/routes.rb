Rails.application.routes.draw do

  root 'posts#index'

  get 'signup' => 'users#new', as: :new_user
  post 'signup' => 'users#create', as: :users

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  # resources :posts, only:[:index,:new,:create]
  resources :posts do
    resources :votes, :only =>[:create]
  end
  resources :users, :only => [:show] do
    resources :votes, :only =>[:create]
  end
  resources :profiles

end
