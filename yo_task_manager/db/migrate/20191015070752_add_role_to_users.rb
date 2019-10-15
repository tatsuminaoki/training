class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE users ADD role enum('admin', 'common') DEFAULT 'common' AFTER login_id, COMMENT 'ロール';
    SQL
  end

  def down
    remove_column :users, :role
  end
end
