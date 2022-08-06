Rails.application.routes.draw do
  post '/reviews', to: 'reviews#reviews'
  root to: 'reviews#index'
end
