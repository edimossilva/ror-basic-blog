Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  
  resources :blogs, :only => [:create, :destroy, :show] do
    resources :posts, :only => [:create, :destroy]
  end
end
