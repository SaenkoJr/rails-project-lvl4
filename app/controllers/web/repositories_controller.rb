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

      client = Octokit::Client.new(access_token: current_user.token, per_page: 200)
      @repos = client.repos
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

      client = Octokit::Client.new(access_token: current_user.token)
      repo = client.repo(repository_params[:github_id].to_i)

      @repository = current_user.repositories.build(
        github_id: repository_params[:github_id],
        name: repo[:name],
        full_name: repo[:full_name],
        link: repo[:html_url],
        language: repo[:language].downcase,
        repo_created_at: repo[:created_at],
        repo_updated_at: repo[:updated_at]
      )

      if @repository.save
        redirect_to @repository, notice: t('.success')
      else
        render :new, alert: t('.failure')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
