Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'hello', to: 'hello#index'
      resources :photos, only: [:index, :create, :show, :update, :destroy]
      resources :users, only: [:create]
      get '/user_photos/:user_id', to: 'photos#user_photos'
    end
  end
end
