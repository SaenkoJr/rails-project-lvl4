# frozen_string_literal: true

class CheckerStub
  def initialize(repo)
    @repo = repo
  end

  def repo_dest
    File.join(Dir.tmpdir, @repo.full_name)
  end

  def lint; end
end
