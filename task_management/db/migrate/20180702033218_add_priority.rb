class AddPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :unsigned_integer, :null => false, :default => 0, :limit => 1
  end
end
