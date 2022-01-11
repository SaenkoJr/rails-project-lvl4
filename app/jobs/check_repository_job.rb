# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :repository

  def perform(check_id)
    pp '------------------------------------------'
    pp check_id
    pp '------------------------------------------'
    CheckerService.new.run(check_id)
  end
end
