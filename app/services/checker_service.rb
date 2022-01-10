# frozen_string_literal: true

class CheckerService
  include Import[:bash_runner]

  LINTERS = {
    javascript: Eslint,
    ruby: Rubocop
  }.freeze

  def run(id)
    check = Repository::Check.find(id)
    repository = check.repository
    check.run!

    loader = RepoLoader.new
    _, stderr, exit_status = loader.clone(repository.link, repository.full_name)

    unless exit_status.success?
      raise stderr
    end

    linter = LINTERS[repository.language.to_sym].new
    result = linter.lint(loader.repo_dest(repository.full_name))

    if result[:passed]
      check.update(passed: true)
      return check.finish!
    end

    check.passed = false
    check.issues.create(result[:issues])
    check.finish
    check.save!
    CheckMailer.with(user: repository.user, check: check).linter_report.deliver_later
  rescue StandardError => e
    check.fail! e.message
    raise e
  end
end
