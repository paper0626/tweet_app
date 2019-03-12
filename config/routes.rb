Rails.application.routes.draw do
  get 'users/index' => 'users#index'
  get 'users/:id/edit' => 'users#edit'
  get 'users/:id' => 'users#show'
  get 'signup' => 'users#new'
  get 'login' => 'users#login_form'
  get 'users/:id/likes' =>'users#likes'
  
  post 'users/create' => 'users#create'
  post 'users/:id/update' => 'users#update'
  post 'users/:id/destroy' => 'users#destroy'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'

  get 'posts/index' => 'posts#index'
  get 'posts/new' => 'posts#new'
  get 'posts/:id/edit' => 'posts#edit'
  get 'posts/:id' => 'posts#show'
  post 'posts/create' => 'posts#create'
  post 'posts/:id/update' => 'posts#update'
  post 'posts/:id/destroy' => 'posts#destroy'
  
  post 'likes/:post_id/create' => 'likes#create'
  post 'likes/:post_id/destroy' => 'likes#destroy'

  get '/' => 'home#top'
  get '/about' => 'home#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
