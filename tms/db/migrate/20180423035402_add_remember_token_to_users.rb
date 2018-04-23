class AddRememberTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remember_token, :string, after: :password_digest
  end
end
