# frozen_string_literal: true

class Checker
  def initialize(check)
    @check = check
  end

  def run
    @check.run!

    loader = ApplicationContainer.resolve(:repo_loader)
    _, stderr, exit_status = loader.clone(@check.repository.link, @check.repository.full_name)

    unless exit_status.success?
      raise stderr
    end

    linter = ApplicationContainer.resolve("linters.#{@check.repository.language}")
    issues, linter_exit_status = linter.lint(loader.repo_dest(@check.repository.full_name))

    unless linter_exit_status.success?
      @check.passed = false
      @check.issues.create(issues)
      @check.save!
      CheckMailer.with(user: @check.repository.user, check: @check).linter_report.deliver_later
    end

    @check.update(passed: true) if linter_exit_status.success?

    @check.finish!
  end
end
