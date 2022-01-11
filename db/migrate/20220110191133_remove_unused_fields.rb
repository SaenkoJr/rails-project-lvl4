class RemoveUnusedFields < ActiveRecord::Migration[6.1]
  def change
    remove_column :repositories, :repo_created_at, :datetime
    remove_column :repositories, :repo_updated_at, :datetime
    remove_column :repositories, :hook_id, :integer
  end
end
