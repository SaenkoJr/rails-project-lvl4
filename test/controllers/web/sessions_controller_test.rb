# frozen_string_literal: true

require 'test_helper'

class Web::SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'log out' do
    sign_in_as_with_github(:one)
    assert { signed_in? }

    delete session_path

    assert_redirected_to root_path
    assert { !signed_in? }
  end
end
