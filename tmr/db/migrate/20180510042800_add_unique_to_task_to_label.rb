class AddUniqueToTaskToLabel < ActiveRecord::Migration[5.2]
  def up
    add_index :task_to_labels, [:task_id, :label_id], unique: true
  end
end
