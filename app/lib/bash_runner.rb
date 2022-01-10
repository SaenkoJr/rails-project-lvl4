# frozen_string_literal: true

class BashRunner
  def self.start(command)
    Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
      [stdout.read, stderr.read, wait_thr.value]
    end
  end
end
