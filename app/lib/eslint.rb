# frozen_string_literal: true

class Eslint
  class << self
    def lint(path)
      command = "yarn run eslint --no-eslintrc -c #{Rails.root.join('.eslintrc.json')} -f json #{path}"

      Open3.popen2(command) do |_stdin, stdout, wait_thr|
        issues = parse(stdout.readlines[2])
        [issues, wait_thr.value]
      end
    end

    private

    def parse(output)
      JSON.parse(output, symbolize_names: true).map do |error|
        error[:messages].map do |msg|
          {
            file_path: error[:filePath],
            rule_id: msg[:ruleId],
            message: msg[:message],
            line: msg[:line],
            column: msg[:column]
          }
        end
      end.flatten
    end
  end
end
