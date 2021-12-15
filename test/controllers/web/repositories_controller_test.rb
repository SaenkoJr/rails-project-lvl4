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
    api_github_url = URI::HTTPS.build(host: 'api.github.com', path: '/user/repos')
    response = load_fixture('files/repositories_response.json')

    sign_in_as_with_github(:one)

    stub_request(:get, api_github_url)
      .to_return(
        status: 200,
        body: response,
        headers: { 'Content-Type': 'application/json' }
      )

    get new_repository_path

    assert_response :success
  end

  test 'GET #show (guest must be redirected)' do
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

    repos = load_fixture('files/repositories_response.json')
    repo = JSON.parse(repos, symbolize_names: true).first
    api_github_url = URI::HTTPS.build(host: 'api.github.com', path: "/repositories/#{repo[:id]}")
    response = repo.to_json

    stub_request(:get, api_github_url)
      .to_return(
        status: 200,
        body: response,
        headers: { 'Content-Type': 'application/json' }
      )

    params = {
      repository: { github_id: repo[:id] }
    }

    assert_difference('Repository.count', +1) do
      post repositories_path, params: params
      assert_redirected_to Repository.last
    end
  end
end
