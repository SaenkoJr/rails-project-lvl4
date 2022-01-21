# frozen_string_literal: true

class Linter::Eslint < Linter::ApplicationLinter
  private

  def command(path)
    "npx eslint --no-eslintrc -c #{Rails.root.join('.eslintrc.json')} -f json #{path}"
  end

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
