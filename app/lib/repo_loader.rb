# frozen_string_literal: true

class RepoLoader
  class << self
    def repo_dest(name)
      File.join(Dir.tmpdir, name)
    end

    def clone(link, name)
      FileUtils.rm_r(repo_dest(name)) if Dir.exist? repo_dest(name)

      Open3.popen2("git clone #{link} #{repo_dest(name)}") do |_stdin, stdout, wait_thr|
        [stdout.read, wait_thr.value]
      end
    end
  end
end
