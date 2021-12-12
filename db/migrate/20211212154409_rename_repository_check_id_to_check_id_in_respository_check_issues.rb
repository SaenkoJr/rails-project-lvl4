class RenameRepositoryCheckIdToCheckIdInRespositoryCheckIssues < ActiveRecord::Migration[6.1]
  def change
    rename_column :repository_check_issues, :repository_check_id, :check_id
  end
end
