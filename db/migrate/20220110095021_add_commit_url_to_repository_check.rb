class AddCommitUrlToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :commit_reference_url, :string
  end
end
