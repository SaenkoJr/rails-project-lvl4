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
    !current_user.nil?
  end

  def current_user
    return nil if session[:user_id].blank?

    @current_user ||= User.find(session[:user_id])
  end
end
