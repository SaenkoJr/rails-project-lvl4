# frozen_string_literal: true

class Linter::ApplicationLinter
  include Import[:bash_runner]

  def lint(path)
    stdout, stderr, exit_status = bash_runner.start(command(path))

    unless stderr.empty?
      raise stderr
    end

    {
      passed: exit_status.success?,
      issues: parse(stdout)
    }
  end

  private

  def command(path)
    raise NotImplementedError
  end

  def parse(output)
    raise NotImplementedError
  end
end
