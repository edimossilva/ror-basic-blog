Rails.application.routes.draw do
  resources :blogs, :only => [:create, :destroy, :show]
  post '/auth/login', to: 'authentication#login'

end
