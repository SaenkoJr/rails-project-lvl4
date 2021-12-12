# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :checker, -> { CheckerStub }
    register :repo_loader, -> { RepoLoaderStub }

    namespace(:linters) do
      register :javascript, -> { EslintStub }
      register :ruby, -> { RubocopStub }
    end
  else
    register :checker, -> { Checker }
    register :repo_loader, -> { RepoLoader }

    namespace(:linters) do
      register :javascript, -> { Eslint }
      register :ruby, -> { Rubocop }
    end
  end
end
