class AddIndexToTask < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :created_at
    add_index :tasks, :due_date
  end
end
