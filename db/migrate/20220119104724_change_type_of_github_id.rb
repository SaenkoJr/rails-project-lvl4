class ChangeTypeOfGithubId < ActiveRecord::Migration[6.1]
  def change
    change_column :repositories, :github_id, :string
  end
end
