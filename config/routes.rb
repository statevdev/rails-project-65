# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/destroy', to: 'auth#destroy', as: :sign_out

    resources :bulletins do
      member do
        patch :archive
        patch :to_moderate
      end
    end

    scope module: :profile do
      get 'profile', to: 'bulletins#index'
    end

    namespace :admin do
      root 'bulletins#under_moderation'

      resources :categories, except: :show

      resources :bulletins, only: %i[index destroy] do
        member do
          patch :publish
          patch :archive
          patch :reject
        end
      end
    end
  end
end
