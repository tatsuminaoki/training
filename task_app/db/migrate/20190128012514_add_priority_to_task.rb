class AddPriorityToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :integer, after: :due_date, limit: 1, null: false
  end
end
