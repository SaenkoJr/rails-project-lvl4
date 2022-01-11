# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :github

  def perform(repo)
    RepositoryService.new.update_info(repo)

    GithubHookJob.perform_later(repo)
  end
end
