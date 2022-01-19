# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    def create
      pp '------------------------------------------'
      pp params
      pp '------------------------------------------'
      repo = Repository.find_by(github_id: params[:repository][:id])
      commit_ref = params.dig(:head_commit, :id)
      commit_ref_url = params.dig(:head_commit, :url)

      if repo.nil?
        render json: { error: t('.not_found') }, status: :not_found and return
      end

      check = repo.checks.build(
        commit_reference: commit_ref,
        commit_reference_url: commit_ref_url
      )
      if check.save
        CheckRepositoryJob.perform_later(check)

        render json: check, status: :ok
      else
        render json: { error: t('.error') }, status: :unprocessable_entity
      end
    end
  end
end
