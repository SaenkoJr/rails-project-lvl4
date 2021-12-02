# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :callback_auth
    match 'auth/failure', to: 'auth#failure', via: %i[get post], as: :failure_auth

    resource :session, only: :destroy
    resources :repositories
  end
end
