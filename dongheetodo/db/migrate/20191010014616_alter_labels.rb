class AlterLabels < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :labels, :tasks
    remove_column :labels, :task_id
    add_column :labels, :color, :integer
    add_index :labels, :name, unique: true
  end
end
