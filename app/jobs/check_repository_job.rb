# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :repository

  def perform(check)
    pp '------------------------------------------'
    pp check
    pp '------------------------------------------'
    CheckerService.new.run(check.id)
  end
end
