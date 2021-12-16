# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    !user.guest?
  end

  def show?
    !user.guest? && author?
  end

  def create?
    !user.guest?
  end
end
