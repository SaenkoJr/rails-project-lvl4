# frozen_string_literal: true

class GithubHookJob < ApplicationJob
  queue_as :github

  def perform(repo_id, access_token)
    repo = Repository.find(repo_id)
    client = Octokit::Client.new(access_token: access_token)
    ApplicationContainer[:github_hook].new(client).create(repo)
  end
end
