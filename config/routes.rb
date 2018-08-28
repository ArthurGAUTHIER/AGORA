Rails.application.routes.draw do
  get '/discover', to: 'media#index', as: 'discover'
  
  get '/dashboard', to: 'users#show', as: 'dashboard'
  devise_for :users
  
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
