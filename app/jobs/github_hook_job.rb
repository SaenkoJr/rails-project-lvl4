# frozen_string_literal: true

class GithubHookJob < ApplicationJob
  queue_as :github

  def perform(id)
    RepositoryService.new.create_hook(id)
  end
end
