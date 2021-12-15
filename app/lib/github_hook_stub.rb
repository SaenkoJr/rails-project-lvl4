# frozen_string_literal: true

class GithubHookStub
  def initialize(client)
    @client = client
  end

  def create(repository); end
end
