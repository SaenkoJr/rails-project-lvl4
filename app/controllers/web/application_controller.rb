# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include Pundit
    include AuthConcern

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      redirect_to root_path, alert: t(:unauthorized)
    end
  end
end
