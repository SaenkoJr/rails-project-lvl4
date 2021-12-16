# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/check_mailer
class CheckMailerPreview < ActionMailer::Preview
  def linter_report
    user = User.first
    check = Repository::Check.failed.first
    CheckMailer.with(user: user, check: check).linter_report
  end

  def crash_report
    user = User.first
    check = Repository::Check.failed.first
    error = StandardError.new 'Something went wrong'
    CheckMailer.with(user: user, check: check, error: error.message).crash_report
  end
end
