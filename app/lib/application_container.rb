# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :checker, -> { CheckerStub }
  else
    register :checker, -> { Checker }
  end
end
