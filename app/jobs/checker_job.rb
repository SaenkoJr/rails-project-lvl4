# frozen_string_literal: true

class CheckerJob < ApplicationJob
  queue_as :repository

  def perform(check_id, user_id)
    check = Repository::Check.find(check_id)
    user = User.find(user_id)
    checker = ApplicationContainer.resolve(:checker).new(check, user)
    checker.lint
  rescue StandardError => e
    check.fail! e.message
  end
end
