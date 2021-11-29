# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'helpers/sign_in'

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(
  :github,
  FactoryBot.generate(:github_auth_hash)
)
Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
end

class ActionDispatch::IntegrationTest
  include SignIn
  include AuthConcern
end
