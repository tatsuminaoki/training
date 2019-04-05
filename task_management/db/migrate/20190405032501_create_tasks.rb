class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.int, :task_id
      t.string, :task_name
      t.string :contents

      t.timestamps
    end
  end
end
