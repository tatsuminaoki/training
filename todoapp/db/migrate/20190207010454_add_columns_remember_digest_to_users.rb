class AddColumnsRememberDigestToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :remember_digest, :string
    add_index :users, :remember_digest
  end
end
