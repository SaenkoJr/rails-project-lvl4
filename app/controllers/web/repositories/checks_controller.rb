# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      after_action :verify_authorized

      def show
        @check = resource_repository.checks.find(params[:id])
        authorize @check

        @q = @check.issues.ransack(ransack_params)
        @issues = @q.result
                    .page(page)
                    .per(per_page)
      end

      def create
        @check = resource_repository.checks.build

        authorize @check

        if @check.save
          CheckRepositoryJob.perform_later(@check)
          flash[:notice] = t('.success')
        else
          flash[:alert] = t('.failure')
        end

        redirect_to repository_path(params[:repository_id])
      end
    end
  end
end
