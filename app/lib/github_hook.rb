# frozen_string_literal: true

class GithubHook
  def initialize(client)
    @client = client
  end

  def create(repository)
    return if hook_exists?(repository.full_name, repository.hook_id)

    hook = @client.create_hook(
      repository.full_name,
      'web',
      { url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json' }
    )

    repository.hook_id = hook.id
    repository.save!
  end

  private

  def hook_exists?(repo_id, hook_id)
    @client.hook(repo_id, hook_id)
  rescue StandardError
    false
  end
end
