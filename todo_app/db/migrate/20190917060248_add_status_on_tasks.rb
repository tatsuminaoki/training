class AddStatusOnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer, after: :name, default: 0
    add_index :tasks, :status
  end
end
