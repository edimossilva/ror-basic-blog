Rails.application.routes.draw do
  resources :blogs, :only => [:create]
  post '/auth/login', to: 'authentication#login'

end
