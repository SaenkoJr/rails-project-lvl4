# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @check = Repository::Check.find(params[:id])
      end

      def create
        CheckerJob.perform_later(params[:repository_id])
        redirect_to repository_path(params[:repository_id])
      end
    end
  end
end
