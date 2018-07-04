class AddStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :unsigned_integer, :null => false, :default => 0, :limit => 1
  end
end
