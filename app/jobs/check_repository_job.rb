# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :repository

  def perform(check_id)
    check = Repository::Check.find(check_id)
    checker = Checker.new(check)
    checker.run
  rescue StandardError => e
    check.fail! e.message
  end
end
