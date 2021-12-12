# frozen_string_literal: true

class RubocopStub
  class << self
    def lint(path); end

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
