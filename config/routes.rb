Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about' #static_pages_about_urlが使えるようになる
  get 'static_pages/contact'
end
