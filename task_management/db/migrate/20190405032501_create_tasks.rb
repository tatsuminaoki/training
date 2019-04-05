class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, id: false do |t|
      t.column :task_id, 'INTEGER PRIMARY KEY AUTO_INCREMENT'
      t.string :task_name
      t.string :contents

      t.timestamps
    end
  end
end
