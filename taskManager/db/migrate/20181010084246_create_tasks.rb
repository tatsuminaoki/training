class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :task_name, null: false
      t.text :description, null: false
      t.integer :user_id, null: false
      t.date :deadline, null: true
      t.integer :priority, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
