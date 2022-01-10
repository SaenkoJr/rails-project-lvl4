# frozen_string_literal: true

class RepoLoader
  include Import[:bash_runner]

  def repo_dest(name)
    File.join(Dir.tmpdir, 'repositories', name)
  end

  def clone(link, name)
    bash_runner.start("rm -rf #{repo_dest(name)}") if Dir.exist? repo_dest(name)

    command = "git clone #{link} #{repo_dest(name)}"

    bash_runner.start(command)
  end
end
