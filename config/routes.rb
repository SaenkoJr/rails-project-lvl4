# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :callback_auth
    match 'auth/failure', to: 'auth#failure', via: %i[get post], as: :failure_auth

    resource :session, only: :destroy
    resources :repositories do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end

  namespace :api do
    post :checks, to: 'checks#index'
  end
end
