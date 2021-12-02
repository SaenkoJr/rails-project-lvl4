# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  enumerize :language, in: AVAILABLE_LANGUAGES

  validates :github_id, presence: true
end
