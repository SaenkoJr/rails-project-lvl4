# frozen_string_literal: true

require 'test_helper'

class UpdateInfoRepositoryJobTest < ActiveJob::TestCase
  test '#create' do
    repo = repositories(:created)
    response = file_fixture('repository.json').read

    UpdateInfoRepositoryJob.perform_now(repo.id)
    repo.reload

    assert repo.full_name == JSON.parse(response)['full_name']
    assert repo.link == JSON.parse(response)['html_url']
    assert repo.fetched?
  end
end
