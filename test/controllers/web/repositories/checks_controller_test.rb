# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:passed)
  end

  test 'GET #show (guest must be redirected)' do
    get repository_check_path(@repository, @check)

    assert_redirected_to root_path
  end

  test 'GET #show (signed in user can see repository`s check)' do
    sign_in_as_with_github(:one)

    get repository_check_path(@repository, @check)

    assert_response :success
  end

  test 'POST #create (guest must be redirected)' do
    post repository_checks_path(@repository)

    assert_redirected_to root_path
  end

  test 'POST #create (the user cannot check repository of other users)' do
    sign_in_as_with_github(:two)

    post repository_checks_path(@repository)

    assert_redirected_to root_path
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
