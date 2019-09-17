class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.bigint :task_id, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_foreign_key :labels, :tasks
  end
end
