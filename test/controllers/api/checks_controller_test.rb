# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'POST #create' do
    repo = repositories(:one)

    payload = {
      repository: { full_name: repo[:full_name] }
    }

    post api_checks_url(params: payload)

    assert_response :ok
  end

  test 'POST #create (repository not found)' do
    payload = {
      repository: { full_name: 'foo' }
    }

    post api_checks_url(params: payload)

    assert_response :not_found
  end
end
