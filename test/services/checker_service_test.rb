# frozen_string_literal: true

require 'test_helper'

class CheckerServiceTest < ActiveSupport::TestCase
  setup do
    @check = repository_checks(:created)
  end

  test 'run check' do
    assert { @check.created? }

    CheckerService.new.run(@check.id)

    @check.reload

    assert { @check.finished? }
    assert { @check.passed }
  end
end
