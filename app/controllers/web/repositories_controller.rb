# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    after_action :verify_authorized

    def index
      authorize Repository
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
      authorize @repository

      @repos = current_user.repos
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
    end

    def create
      authorize Repository

      if repository_params[:github_id].empty?
        redirect_to new_repository_path, alert: t('.empty_github_id') and return
      end

      @repository = current_user.repositories
                                .find_or_initialize_by(github_id: repository_params[:github_id])

      if @repository.save
        UpdateInfoRepositoryJob.perform_later(@repository.id)
        redirect_to @repository, notice: t('.success')
      else
        flash[:alert] = t('.failure')
        render :new
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
