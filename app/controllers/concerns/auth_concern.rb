# frozen_string_literal: true

module AuthConcern
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    !current_user.guest?
  end

  def current_user
    return Guest.new if session[:user_id].blank?

    @current_user ||= User.find(session[:user_id])
  end

  def verify_token
    return unless current_user.token_expired?

    sign_out
    redirect_to root_path, alert: t(:session_expired)
  end
end
