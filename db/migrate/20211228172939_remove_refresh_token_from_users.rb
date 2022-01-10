class RemoveRefreshTokenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :token_expires_at, :integer
  end
end
