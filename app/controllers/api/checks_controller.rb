# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    def create
      repo = Repository.find_by(full_name: params[:repository][:full_name])

      if repo.nil?
        render json: { error: t('.not_found') }, status: :not_found and return
      end

      check = repo.checks.build

      if check.save
        CheckRepositoryJob.perform_later(check)

        render json: check, status: :ok
      else
        render json: { error: t('.error') }, status: :unprocessable_entity
      end
    end
  end
end
