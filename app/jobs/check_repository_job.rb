# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :repository

  def perform(check_id)
    CheckerService.new.run(check_id)
  end
end
