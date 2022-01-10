# frozen_string_literal: true

require 'test_helper'

class CheckRepositoryJobTest < ActiveJob::TestCase
  test 'run check' do
    check = repository_checks(:created)

    CheckRepositoryJob.perform_now(check.id)
    check.reload

    assert { check.finished? }
    assert { check.passed }
  end
end
