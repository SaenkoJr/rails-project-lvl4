# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:passed)
  end

  test 'GET #show (signed in user can see repository`s check)' do
    sign_in_as_with_github(:one)

    get repository_check_path(@repository, @check)

    assert_response :success
  end

  test 'POST #create (signed in user can see repository`s check)' do
    sign_in_as_with_github(:one)

    post repository_checks_path(@repository)

    check = Repository::Check.last

    assert_redirected_to repository_path(@repository)
    assert { check.created? }
    assert { check.repository == @repository }
    assert_enqueued_with job: CheckRepositoryJob
  end
end
