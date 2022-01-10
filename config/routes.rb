# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :callback_auth
    match 'auth/failure', to: 'auth#failure', via: %i[get post], as: :failure_auth
    delete 'auth/destroy', to: 'auth#destroy', as: :sign_out

    resources :repositories, only: %i[index new show create] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end

  namespace :api do
    post :checks, to: 'checks#create'
  end
end
