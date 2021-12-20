# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'POST #index' do
    repo = repositories(:one)

    payload = {
      repository: { id: repo[:github_id] }
    }

    post api_checks_url(params: payload)

    assert_response :ok
  end
end
