class CreateRepositoryCheckIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_check_issues do |t|
      t.text :message
      t.text :rule_id
      t.string :file_path
      t.integer :line
      t.integer :column
      t.references :repository_check, null: false, foreign_key: true

      t.timestamps
    end
  end
end
