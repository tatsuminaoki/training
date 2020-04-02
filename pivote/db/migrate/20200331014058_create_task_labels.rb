class CreateTaskLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :task_labels do |t|
      t.references :task, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end

    add_index :task_labels, [:task_id, :label_id], unique: true
  end
end
