# frozen_string_literal: true

FactoryBot.define do
  sequence :email do
    Faker::Internert.email
  end

  sequence :nickname do
    Faker::Internert.username
  end

  sequence :github_auth_hash do
    Faker::Omniauth.github
  end
end
