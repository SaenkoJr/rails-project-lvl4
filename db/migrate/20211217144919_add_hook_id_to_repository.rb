class AddHookIdToRepository < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :hook_id, :integer
  end
end
