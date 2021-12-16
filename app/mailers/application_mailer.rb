# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'check-report@quality-code-checker.com'
  layout 'mailer'
end
