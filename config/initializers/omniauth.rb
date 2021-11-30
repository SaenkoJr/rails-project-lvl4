# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: %i[email nickname] unless Rails.env.production?
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], scope: 'user,repo,admin:repo_hook'
end
