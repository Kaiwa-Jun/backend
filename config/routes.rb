Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'hello', to: 'hello#index'
      resources :users, only: [:create]
      get '/user_photos/:user_id', to: 'photos#user_photos'
      resources :photos, only: [:index, :create, :show, :update, :destroy] do
        resources :comments, only: [:index, :create]
      end
    end
  end
  match 'api/*path', to: redirect('/api/v1/%{path}'), via: [:get, :post, :put, :patch, :delete]
end
