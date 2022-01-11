# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      before_action :set_repo
      after_action :verify_authorized

      def show
        @check = @repo.checks.find(params[:id])
        authorize @check

        @q = @check.issues.ransack(ransack_params)
        @issues = @q.result
                    .page(page)
                    .per(per_page)
      end

      def create
        @check = @repo.checks.build

        authorize @check

        commit = @repo.last_commit
        @check.commit_reference = commit[:sha]
        @check.commit_reference_url = commit[:html_url]

        if @check.save
          CheckRepositoryJob.perform_later(@check.id)
          flash[:notice] = t('.success')
        else
          flash[:alert] = t('.failure')
        end

        redirect_to repository_path(params[:repository_id])
      end

      private

      def set_repo
        @repo = Repository.find(params[:repository_id])
      end
    end
  end
end
