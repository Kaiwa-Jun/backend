Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'hello', to: 'hello#index'
      resources :users, only: [:create]
      get '/user_photos/:user_id', to: 'photos#user_photos'
      resources :photos, only: [:index, :create, :show, :update, :destroy] do
        resources :comments, only: [:index, :create]
        resource :likes, only: [:show, :create, :destroy]
      end
    end
  end
end
