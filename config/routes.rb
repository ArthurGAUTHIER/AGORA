Rails.application.routes.draw do
  get '/discover', to: 'media#index', as: 'discover'

  get '/dashboard', to: 'users#show', as: 'dashboard'
  devise_for :users

  root to: 'pages#home'

  resources :media, only: [] do
    resources :libraries, only: [:create]
  end

  resources :categories, only: [] do
    resources :preference_categories, only: [:create]
  end

  resources :moods, only: [] do
    resources :preference_moods, only: [:create]
  end
end
