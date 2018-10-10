class AddIndexTaskLabel < ActiveRecord::Migration[5.2]
  def change
    add_index :task_labels, [:task_id, :label_id], :name => 'unique_task_label', :unique => true
  end
end
