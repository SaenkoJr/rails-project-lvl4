# frozen_string_literal: true

class GithubClient
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, per_page: 200)
  end

  def repos
    @client.repos
  end

  def repo(github_id)
    @client.repo(github_id)
  end

  def hooks(github_id)
    @client.hooks(github_id)
  end

  def commits(github_id, branch: :master)
    @client.commits(github_id, branch: branch)
  end

  def create_hook(repository)
    return if hook_exists?(repository.github_id.to_i)

    @client.create_hook(
      repository.full_name,
      'web',
      { url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json' }
    )

    repository.save!
  end

  private

  def hook_exists?(github_id)
    hooks(github_id).one? do |hook|
      hook[:config][:url] == Rails.application.routes.url_helpers.api_checks_url
    end
  end
end
