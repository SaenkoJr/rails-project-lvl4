# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include Pundit
    include AuthConcern

    RANSACK_DEFAUTLT_SORT = 'created_at DESC'

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      redirect_to root_path, alert: t(:unauthorized)
    end

    def ransack_params
      params.fetch(:q, { s: RANSACK_DEFAUTLT_SORT })
    end

    def page
      params.fetch(:page, 1)
    end

    def per_page
      params.fetch(:per_page, 10)
    end
  end
end
