# frozen_string_literal: true

class CheckerJob < ApplicationJob
  queue_as :repository

  def perform(repository_id)
    repo = Repository.find(repository_id)
    checker = ApplicationContainer[:checker].new(repo)
    checker.lint
  end
end
