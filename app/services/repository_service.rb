# frozen_string_literal: true

class RepositoryService
  include Import[:github_client]

  def update_info(id)
    repo = Repository.find(id)
    repo.fetch!

    client = github_client.new(repo.user.token)
    data = client.repo(repo.github_id.to_i)

    repo.name = data[:name]
    repo.full_name = data[:full_name]
    repo.link = data[:html_url]
    repo.language = data[:language].downcase
    repo.mark_as_fetched
    repo.save!
  rescue StandardError => e
    repo.fail!
    raise e
  end

  def create_hook(repo_id)
    repo = Repository.find(repo_id)
    client = github_client.new(repo.user.token)
    client.create_hook(repo)
  end
end
