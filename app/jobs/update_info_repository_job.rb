# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :github

  def perform(github_id, access_token)
    repo = Repository.find_by(github_id: github_id)
    repo.fetch!

    client = Octokit::Client.new(access_token: access_token)
    data = client.repo(github_id.to_i)

    repo.name = data[:name]
    repo.full_name = data[:full_name]
    repo.link = data[:html_url]
    repo.language = data[:language].downcase
    repo.repo_created_at = data[:created_at]
    repo.repo_updated_at = data[:updated_at]
    repo.done
    repo.save!

    GithubHookJob.perform_later(repo.id, access_token)
  rescue StandardError
    repo.fail!
  end
end
