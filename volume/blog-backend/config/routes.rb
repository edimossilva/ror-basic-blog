Rails.application.routes.draw do
  resources :blogs, :only => [:create]
end
