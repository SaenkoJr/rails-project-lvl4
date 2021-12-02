# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  def guest?
    false
  end

  def token_expired?
    return false if token_expires_at.nil?

    Time.zone.at(token_expires_at).to_datetime <= DateTime.current
  end
end
