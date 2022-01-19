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

  def commits
    client = ApplicationContainer[:github_client].new(user.token)

    client.commits(github_id.to_i)
  end

  def last_commit
    commits.first
  end

  def check_passed?
    checks.last.passed
  end

  def hooks
    client = ApplicationContainer[:github_client].new(user.token)

    client.hooks(github_id.to_i)
  end
end
