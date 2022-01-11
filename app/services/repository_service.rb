# frozen_string_literal: true

class RepositoryService
  include Import[:github_client]

  def update_info(repo)
    pp '------------------------------------------'
    pp repo.may_fetch?
    pp '------------------------------------------'

    repo.fetch!

    client = github_client.new(repo.user.token)
    data = client.repo(repo.github_id)

    repo.name = data[:name]
    repo.full_name = data[:full_name]
    repo.link = data[:html_url]
    repo.language = data[:language].downcase
    repo.done
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
