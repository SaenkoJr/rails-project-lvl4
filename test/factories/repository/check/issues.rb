# frozen_string_literal: true

FactoryBot.define do
  factory :repository_check_issue, class: 'Repository::Check::Issue' do
    message { 'MyText' }
    rule { 'MyText' }
    line_column { 'MyString' }
    repository_check { nil }
  end
end
