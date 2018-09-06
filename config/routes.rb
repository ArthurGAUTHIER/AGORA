Rails.application.routes.draw do
  post '/chatbot', to: 'media#chatbot'

  get '/discover', to: 'media#index', as: 'discover'

  get '/dashboard', to: 'users#show', as: 'dashboard'
  devise_for :users

  scope :bot do
    post 'send', to: 'bot#send_message', as: :bot_send
  end

  root to: 'pages#home'

  resources :media, only: [] do
    resources :libraries, only: [:create]
    resources :reviews, only: [:create]
  end

  resources :categories, only: [] do
    resources :preference_categories, only: [:create, :destroy]
  end

  resources :moods, only: [] do
    resources :preference_moods, only: [:create, :destroy]
  end

  resources :topics, only: [:index, :create, :show, :destroy]
  resources :comments, only: [:create, :destroy]
end
