# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    def index
      repo = Repository.find_by(github_id: params[:repository][:id])
      check = repo.checks.build
      CheckerJob.perform_later(check.id) if check.save

      respond_with :api, check
    end
  end
end
