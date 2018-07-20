class AddColumnToTask3 < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :integer, default: 0, null: false
    add_index :tasks, :priority
  end
end
