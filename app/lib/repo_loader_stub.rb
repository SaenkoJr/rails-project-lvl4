# frozen_string_literal: true

class RepoLoaderStub
  class << self
    def repo_dest(name)
      File.join(Dir.tmpdir, name)
    end

    def clone(link, name); end
  end
end
