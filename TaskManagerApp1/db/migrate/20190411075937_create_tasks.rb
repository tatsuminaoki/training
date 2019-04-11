class CreateTasks < ActiveRecord::Migration[5.2]
  def up
    create_table :tasks do |t|
      t.integer :user_id, :null => false
      t.string :task_title, :null => false
      t.text :task_detail, :null => false
      t.datetime :deadline_date, :null => false
      t.integer :priority, :null => false
      t.integer :task_status_id, :null => false
      t.integer :task_type_id, :null => false
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def down
      drop_table :tasks
  end
end
