# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  test 'GET #show' do
    get repository_check_path(@repository, @check)

    assert_response :success
  end

  test 'POST #create' do
    get repository_check_path(@repository, @check)

    assert_response :success
  end
end
