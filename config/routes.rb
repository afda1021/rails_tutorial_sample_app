Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to:'static_pages#about' #static_pages_about_urlが使えるようになる
  get '/contact', to:'static_pages#contact'
  get '/signup', to: 'users#new' # 本来は get "/users/new"
  post '/signup', to: 'users#create' # 本来は post "/users/create"
  # get 'sessions/new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
end
