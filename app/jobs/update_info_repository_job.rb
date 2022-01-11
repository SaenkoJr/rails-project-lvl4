# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :github

  def perform(id)
    repo = Repository.find(id)
    RepositoryService.new.update_info(repo)

    GithubHookJob.perform_later(id)
  end
end
