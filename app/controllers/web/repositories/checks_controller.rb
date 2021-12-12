# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @check = Repository::Check.find(params[:id])
      end

      def create
        @check = Repository::Check.new(repository_id: params[:repository_id])
        if @check.save
          CheckerJob.perform_later(@check.id)
          flash[:notice] = t('.success')
        else
          flash[:alert] = t('.failure')
        end

        redirect_to repository_path(params[:repository_id])
      end
    end
  end
end
