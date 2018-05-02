class CreateTaskLabel < ActiveRecord::Migration[5.2]
  def up
    create_table :task_labels do |t|
      t.references :task, foreign_key: true
      t.references :label, foreign_key: true

      t.index      [:task_id, :label_id], unique: true
      t.timestamps
    end
  end
  def down
    drop_table :task_labels
  end
end
