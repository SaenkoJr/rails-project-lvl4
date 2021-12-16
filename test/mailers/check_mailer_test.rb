# frozen_string_literal: true

require 'test_helper'

class CheckMailerTest < ActionMailer::TestCase
  test 'linter report' do
    user = users(:one)
    check = repository_checks(:failed)
    mail = CheckMailer.with(user: user, check: check).linter_report

    assert_equal [user.email], mail.to
    assert_equal I18n.t('subject', scope: 'check_mailer.linter_report'), mail.subject
    assert_match I18n.t('check_number', check_id: check.id, scope: 'check_mailer.linter_report'), mail.body.encoded
    assert_match I18n.t('message', scope: 'check_mailer.linter_report'), mail.body.encoded
  end

  test 'crash report' do
    user = users(:one)
    check = repository_checks(:failed)
    error = 'Somthing went wrong'
    mail = CheckMailer.with(user: user, check: check, error: error).crash_report

    assert_equal [user.email], mail.to
    assert_equal I18n.t('subject', scope: 'check_mailer.crash_report'), mail.subject
    assert_match I18n.t('check_number', check_id: check.id, scope: 'check_mailer.crash_report'), mail.body.encoded
    assert_match I18n.t('crash_msg', error: error, scope: 'check_mailer.crash_report'), mail.body.encoded
  end
end
