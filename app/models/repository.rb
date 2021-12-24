# frozen_string_literal: true

class Repository < ApplicationRecord
  include AASM
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: AVAILABLE_LANGUAGES

  validates :github_id, presence: true

  aasm do
    state :created, initial: true
    state :fetching
    state :fetched
    state :failed

    event :fetch do
      transitions from: %i[created fetched failed], to: :fetching
    end

    event :done do
      transitions from: :fetching, to: :fetched
    end

    event :fail do
      transitions from: :fetching, to: :failed
    end
  end
end
