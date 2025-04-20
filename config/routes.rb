# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/destroy', to: 'auth#destroy', as: :sign_out

    resources :bulletins, only: %i[index show new create]

    namespace :admin do
      root 'bulletins#index'
      resources :categories
      resources :bulletins, only: %i[index show destroy]
    end
  end
end
