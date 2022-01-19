# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :github

  def perform(repo)
    pp '------------------------------------------'
    pp repo
    pp '------------------------------------------'
    RepositoryService.new.update_info(repo.id)

    GithubHookJob.perform_later(repo.id)
  end
end
