# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :bash_runner, -> { BashRunnerStub }
    register :github_client, -> { GithubClientStub }
  else
    register :bash_runner, -> { BashRunner }
    register :github_client, -> { GithubClient }
  end
end
