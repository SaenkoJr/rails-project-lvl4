# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository
  has_many :issues, dependent: :destroy

  aasm do
    state :created, initial: true
    state :running
    state :finished
    state :failed

    event :run do
      transitions from: :created, to: :running
    end

    event :finish do
      transitions from: :running, to: :finished
    end

    event :fail do
      transitions from: %i[created running finished], to: :failed
    end
  end

  def send_check_report
    CheckMailer.with(user: repository.user, check: self).linter_report.deliver_later
  end
end
