# frozen_string_literal: true

class Rubocop
  class << self
    def lint(path)
      command = "bundle exec rubocop --format json #{path}"

      Open3.popen2(command) do |_stdin, stdout, wait_thr|
        issues = parse(stdout.read)
        [issues.flatten, wait_thr.value]
      end
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
end
