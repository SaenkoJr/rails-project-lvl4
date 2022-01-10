# frozen_string_literal: true

class GithubClientStub
  def initialize(token); end

  def repos
    load_fixture('repositories_response.json')
  end

  def repo(_id)
    load_fixture('repository.json')
  end

  def hooks(_id)
    []
  end

  def commits(_id)
    [
      {
        sha: '123456',
        html_url: 'www.htmlurl.com'
      }
    ]
  end

  def create_hook(_repository)
    load_fixture('hook.json')
  end

  private

  def load_fixture(filename)
    path = Rails.root.join("test/fixtures/files/#{filename}")
    JSON.parse File.read(path), symbolize_names: true
  end
end
