class DelColumnToTaskLabel < ActiveRecord::Migration[5.2]
  def change
    remove_column :task_labels, :label_user_id, :int
  end
end
