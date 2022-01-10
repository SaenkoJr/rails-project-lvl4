# frozen_string_literal: true

class BashRunnerStub
  class << self
    def start(_command)
      [output, '', exit_status]
    end

    private

    def output
      '[]'
    end

    def exit_status
      status = Struct.new(:status_code) do
        def exitstatus
          status_code
        end

        def success?
          true
        end
      end

      status.new(0)
    end
  end
end
