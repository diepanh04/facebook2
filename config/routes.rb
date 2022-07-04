Rails.application.routes.draw do
  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', edit: 'profile', sign_up: 'registration'}, 
              controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do  
    get '/sign_out' => 'devise/sessions#destroy'  
    get '/users/:id/edit' => 'users#edit_profile', as: :edit_profile    
    patch '/users/:id/edit' => 'users#update_profile', as: :update_profile  
  end

  resources :users
  resources :posts 
  resources :likes 
  resources :comments 
  resources :friendships
  resources :friend_requests
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"
end
