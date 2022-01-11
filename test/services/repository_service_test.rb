# frozen_string_literal: true

require 'test_helper'

class RepositoryServiceTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:created)
  end

  test 'update repository info' do
    json = JSON.parse file_fixture('repository.json').read

    assert { @repo.full_name.nil? }

    RepositoryService.new.update_info(@repo)

    @repo.reload

    assert { @repo.fetched? }
    assert { @repo.name == json['name'] }
    assert { @repo.full_name == json['full_name'] }
    assert { @repo.language == json['language'].downcase }
  end

  test 'create hook' do
    assert { @repo.hooks.empty? }

    hook = RepositoryService.new.create_hook(@repo.id)

    assert { hook[:active] }
    assert { hook[:config][:url] == 'https://example.com/api/checks' }
  end
end
