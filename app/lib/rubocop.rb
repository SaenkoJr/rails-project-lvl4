# frozen_string_literal: true

class Rubocop
  include Import[:bash_runner]

  def lint(path)
    command = "bundle exec rubocop -c #{Rails.root.join('.rubocop.yml')} --format json #{path}"

    stdout, stderr, exit_status = bash_runner.start(command)

    unless stderr.empty?
      raise stderr
    end

    {
      passed: exit_status.success?,
      issues: parse(stdout)
    }
  end

  private

  def parse(output)
    issues = JSON.parse(output, symbolize_names: true)
    issues[:files]
      .reject { |issue| issue[:offenses].empty? }
      .map do |issue|
        issue[:offenses].map do |offense|
          {
            file_path: issue[:path],
            rule_id: offense[:cop_name],
            message: offense[:message],
            line: offense[:location][:start_line],
            column: offense[:location][:start_column]
          }
        end
      end
      .flatten
  end
end
