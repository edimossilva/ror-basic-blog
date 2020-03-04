Rails.application.routes.draw do
  resources :blogs, :only => [:create, :destroy]
  post '/auth/login', to: 'authentication#login'

end
