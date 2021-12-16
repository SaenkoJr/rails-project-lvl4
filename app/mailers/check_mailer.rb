# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def linter_report
    @user = params[:user]
    @check = params[:check]
    mail(
      subject: t('.subject'),
      to: email_address_with_name(@user.email, @user.nickname)
    )
  end

  def crash_report
    @user = params[:user]
    @check = params[:check]
    @error = params[:error]

    mail(
      subject: t('.subject'),
      to: email_address_with_name(@user.email, @user.nickname)
    )
  end
end
