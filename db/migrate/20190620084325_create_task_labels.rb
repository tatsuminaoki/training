class CreateTaskLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :task_labels do |t|
      t.integer :task_id, null: false, unsigned: true
      t.integer :label_id, null: false, unsigned: true

      t.timestamps
    end

    add_index :task_labels, [:task_id, :label_id], name:'index_task_label_on_uniq_key', :unique => true
  end
end
