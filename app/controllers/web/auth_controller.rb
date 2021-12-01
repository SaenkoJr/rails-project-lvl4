# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    skip_before_action :verify_authenticity_token, only: :callback

    def callback
      user = User.find_or_initialize_by(email: auth.info.email)

      user.nickname = auth.info.nickname
      user.token = auth.credentials.token
      user.save!

      sign_in user
      redirect_to root_path, notice: t('.success')
    end

    private

    def auth
      request.env['omniauth.auth']
    end
  end
end
