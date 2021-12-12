# frozen_string_literal: true

class Checker
  def initialize(check)
    @check = check
  end

  def lint
    @check.run!

    loader = ApplicationContainer.resolve(:repo_loader)
    _, exit_status = loader.clone(@check.repository.link, @check.repository.full_name)

    if exit_status.exitstatus.positive?
      @check.fail! and return
    end

    linter = ApplicationContainer.resolve("linters.#{@check.repository.language}")
    issues, exit_code = linter.lint(loader.repo_dest(@check.repository.full_name))

    if exit_code.positive?
      @check.passed = false
      @check.issues.create(issues)
      @check.save!
    end

    @check.update(passed: true) if exit_code.zero?

    @check.finish!
  end
end
