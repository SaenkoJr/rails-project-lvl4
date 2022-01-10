# frozen_string_literal: true

class Eslint
  include Import[:bash_runner]

  def lint(path)
    command = "npx eslint --no-eslintrc -c #{Rails.root.join('.eslintrc.json')} -f json #{path}"

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
    issues
      .reject { |issue| issue[:messages].empty? }
      .map do |issue|
        issue[:messages].map do |msg|
          {
            file_path: issue[:filePath],
            rule_id: msg[:ruleId],
            message: msg[:message],
            line: msg[:line],
            column: msg[:column]
          }
        end
      end.flatten
  end
end
