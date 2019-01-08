class AddStatusColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer, default: 0, null: false, limit: 1, after: :user_id
    add_index :tasks, :status
  end
end
