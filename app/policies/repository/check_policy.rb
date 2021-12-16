# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    !user.guest?
  end

  def create?
    !user.guest? && repository_author?
  end

  private

  def repository_author?
    record.repository.user == user
  end
end
