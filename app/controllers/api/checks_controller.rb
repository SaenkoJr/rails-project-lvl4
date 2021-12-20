# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    def index
      repo = Repository.find_by(github_id: params[:repository][:id])
      check = repo.checks.build
      CheckerJob.perform_later(check.id) if check.save

      render json: check, status: :ok
    end
  end
end
