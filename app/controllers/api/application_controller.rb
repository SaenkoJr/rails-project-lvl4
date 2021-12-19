# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include AuthConcern

    respond_to :json
  end
end
