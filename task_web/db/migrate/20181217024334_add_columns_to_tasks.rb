class AddColumnsToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :due_date, :date, null: false, after: :description
    add_column :tasks, :priority, :integer, default: 0, null: false, limit: 1, after: :due_date
  end
end
