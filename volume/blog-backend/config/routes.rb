Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'

  resources :blogs, only: %i[create destroy index show] do
    resources :posts, only: %i[create destroy show]
  end

  mount ActionCable.server => '/cable'
end
