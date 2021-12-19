# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :verify_token
    after_action :verify_authorized

    before_action :set_github_client, only: %i[new create]

    def index
      authorize Repository
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
      authorize @repository

      @repos = @client.repos
                      .filter { |repo| !repo.language.nil? }
                      .filter { |repo| AVAILABLE_LANGUAGES.include? repo.language.downcase }
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

      repo = @client.repo(repository_params[:github_id].to_i)

      @repository = current_user.repositories.find_or_initialize_by(github_id: repository_params[:github_id])
      @repository.name = repo[:name]
      @repository.full_name = repo[:full_name]
      @repository.link = repo[:html_url]
      @repository.language = repo[:language].downcase
      @repository.repo_created_at = repo[:created_at]
      @repository.repo_updated_at = repo[:updated_at]

      if @repository.save
        GithubHookJob.perform_later(@repository.id, current_user.token)
        redirect_to @repository, notice: t('.success')
      else
        flash[:alert] = t('.failure')
        render :new
      end
    end

    private

    def set_github_client
      @client = Octokit::Client.new(access_token: current_user.token)
    end

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
