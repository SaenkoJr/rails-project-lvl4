# frozen_string_literal: true

class GithubHookJob < ApplicationJob
  queue_as :github

  def perform(repo)
    RepositoryService.new.create_hook(repo.id)
  end
end
