Rails.application.routes.draw do
  get '/discover', to: 'media#index', as: 'discover'

  get '/dashboard', to: 'users#show', as: 'dashboard'
  devise_for :users

  root to: 'pages#home'

  resources :categories do
    resources :preference_categories, only: [:create]
  end

  resources :moods do
    resources :preference_moods, only: [:create]
  end
end
