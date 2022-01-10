# frozen_string_literal: true

class GithubClient
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, per_page: 200)
  end

  def repos
    @client.repos
  end

  def repo(id)
    @client.repo(id)
  end

  def hooks(id)
    @client.hooks(id)
  end

  def create_hook(repository)
    return if hook_exists?(repository.github_id)

    @client.create_hook(
      repository.full_name,
      'web',
      { url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json' }
    )

    repository.save!
  end

  private

  def hook_exists?(id)
    hooks(id).one? do |hook|
      hook[:config][:url] == Rails.application.routes.url_helpers.api_checks_url
    end
  end
end
