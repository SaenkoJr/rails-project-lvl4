# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :github

  def perform(id)
    RepositoryService.new.update_info(id)

    GithubHookJob.perform_later(id)
  end
end
