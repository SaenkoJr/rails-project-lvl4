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

    event :fail, after: proc { |error| send_crash_report(error) } do
      transitions from: %i[created running finished], to: :failed
    end
  end

  def send_crash_report(error)
    CheckMailer.with(
      user: repository.user,
      check: self,
      error: error
    ).crash_report.deliver_later
  end
end
