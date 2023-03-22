Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'hello', to: 'hello#index'
    end
  end
end
