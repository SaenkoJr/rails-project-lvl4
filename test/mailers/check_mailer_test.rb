# frozen_string_literal: true

require 'test_helper'

class CheckMailerTest < ActionMailer::TestCase
  test 'linter report' do
    user = users(:one)
    check = repository_checks(:failed)
    mail = CheckMailer.with(user: user, check: check).linter_report

    assert_equal [user.email], mail.to
    assert_equal I18n.t('subject', scope: 'check_mailer.linter_report'), mail.subject
  end
end
