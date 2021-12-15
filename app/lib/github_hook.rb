# frozen_string_literal: true

class GithubHook
  def initialize(client)
    @client = client
  end

  def create(repository)
    @client.create_hook(
      repository.full_name,
      'web',
      { url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json' }
    )
  end
end
