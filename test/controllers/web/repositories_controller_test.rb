# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'GET #index (guest must be redirected)' do
    get repositories_path

    assert_redirected_to root_path
  end

  test 'GET #index (signed in user can get index page)' do
    sign_in_as_with_github(:one)

    get repositories_path

    assert_response :success
  end

  test 'GET #new (guest must be redirected)' do
    get new_repository_path

    assert_redirected_to root_path
  end

  test 'GET #new (signed in user can get new page)' do
    sign_in_as_with_github(:one)

    get new_repository_path

    assert_response :success
  end

  test 'GET #show (guest must be redirected)' do
    get repository_path(repositories(:one))

    assert_redirected_to root_path
  end

  test 'GET #show (the user cannot view the repository of other users)' do
    sign_in_as_with_github(:two)

    get repository_path(repositories(:one))

    assert_redirected_to root_path
  end

  test 'GET #show (signed in user can see repository)' do
    sign_in_as_with_github(:one)

    repo = repositories(:one)
    get repository_path(repo)

    assert_response :success
  end

  test 'POST #create (guest must be redirected)' do
    params = {
      repository: attributes_for(:repository)
    }

    assert_no_difference('Repository.count') do
      post repositories_path, params: params
      assert_redirected_to root_path
    end
  end

  test 'POST #create (signed in user can create repository)' do
    sign_in_as_with_github(:one)

    json = file_fixture('repository.json').read
    attrs = JSON.parse(json, symbolize_names: true)

    params = {
      repository: { github_id: attrs[:id] }
    }

    assert_difference('Repository.count', +1) do
      post repositories_path, params: params

      repo = Repository.find_by(github_id: attrs[:id])
      assert_redirected_to repository_path(repo)
      assert { repo.created? }
      assert_enqueued_with job: UpdateInfoRepositoryJob
    end
  end
end
