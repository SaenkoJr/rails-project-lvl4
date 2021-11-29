# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      redirect_to root_path, alert: t(:not_authorized)
    end
  end
end
