# frozen_string_literal: true

class GithubClient
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, per_page: 200)
  end

  def repos
    @client.repos
  end

  def repo(repo_id)
    @client.repo(repo_id)
  end

  def hooks(repo_id)
    @client.hooks(repo_id)
  end

  def commits(repo_id, branch: :master)
    @client.commits(repo_id, branch: branch)
  end

  def create_hook(repository)
    return if hook_exists?(repository.full_name)

    @client.create_hook(
      repository.full_name,
      'web',
      { url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json' }
    )

    repository.save!
  end

  private

  def hook_exists?(repo_id)
    hooks(repo_id).one? do |hook|
      hook[:config][:url] == Rails.application.routes.url_helpers.api_checks_url
    end
  end
end
