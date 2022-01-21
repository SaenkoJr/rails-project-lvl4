# frozen_string_literal: true

class CheckerService
  include Import[:bash_runner]

  LINTERS = {
    javascript: Linter::Eslint,
    ruby: Linter::Rubocop
  }.freeze

  def run(id)
    check = Repository::Check.find(id)
    repository = check.repository
    commit = repository.last_commit
    check.run!

    loader = RepoLoader.new
    _, stderr, exit_status = loader.clone(repository.link, repository.full_name)

    unless exit_status.success?
      raise stderr
    end

    linter = LINTERS[repository.language.to_sym].new
    dest = loader.repo_dest(repository.full_name)
    result = linter.lint(dest)

    check.commit_reference = commit[:sha]
    check.commit_reference_url = commit[:html_url]

    if result[:passed]
      check.passed = true
      check.finish
      return check.save!
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
