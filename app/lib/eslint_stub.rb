# frozen_string_literal: true

class EslintStub
  class << self
    def lint(path); end

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
