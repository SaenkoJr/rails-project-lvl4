# frozen_string_literal: true

class Checker
  def initialize(repo)
    @repo = repo
  end

  def repo_dest
    File.join(Dir.tmpdir, @repo.full_name)
  end

  def lint
    check = @repo.checks.create
    check.run!

    FileUtils.rm_r(repo_dest) if Dir.exist? repo_dest

    _, exit_status = Open3.popen2("git clone #{@repo.link} #{repo_dest}") do |_stdin, stdout, wait_thr|
      [stdout.read, wait_thr.value]
    end

    if exit_status.exitstatus.positive?
      check.fail! and return
    end

    output, exit_code = Open3.popen2("yarn run eslint --no-eslintrc -c #{Rails.root.join('.eslintrc.json')} -f json #{repo_dest}") do |_stdin, stdout, wait_thr|
      [stdout.readlines[2], wait_thr.value.exitstatus]
    end

    if exit_code.positive?
      issues = JSON.parse(output, symbolize_names: true).map do |error|
        error[:messages].map do |msg|
          {
            file_path: error[:filePath],
            rule_id: msg[:ruleId],
            message: msg[:message],
            line: msg[:line],
            column: msg[:column]
          }
        end
      end

      check.passed = false
      check.issues.create(issues.flatten)
      check.save!
    end

    check.update(passed: true) if exit_code.zero?

    check.finish!
  end
end
