class AddRefreshTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token_expires_at, :integer
  end
end
