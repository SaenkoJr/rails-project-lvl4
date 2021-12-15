# frozen_string_literal: true

class CheckerJob < ApplicationJob
  queue_as :repository

  def perform(check_id)
    check = Repository::Check.find(check_id)
    checker = ApplicationContainer.resolve(:checker).new(check)
    checker.lint
  rescue StandardError
    checker.fail!
  end
end
