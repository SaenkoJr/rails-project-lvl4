class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state
      t.boolean :passed
      t.string :commit_reference
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
