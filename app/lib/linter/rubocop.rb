# frozen_string_literal: true

class Linter::Rubocop < Linter::ApplicationLinter
  private

  def command(path)
    "bundle exec rubocop -c #{Rails.root.join('.rubocop.yml')} --format json #{path}"
  end

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
