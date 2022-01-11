# frozen_string_literal: true

module IssueHelper
  def format_filepath(path)
    Pathname.new(path).sub('/tmp/repositories/', '')
  end
end
