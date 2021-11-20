# frozen_string_literal: true

module Web
  class SessionsController < Web::ApplicationController
    def destroy
      sign_out
      redirect_to root_path
    end
  end
end
