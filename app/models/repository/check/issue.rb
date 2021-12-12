# frozen_string_literal: true

class Repository::Check::Issue < ApplicationRecord
  belongs_to :check
end
