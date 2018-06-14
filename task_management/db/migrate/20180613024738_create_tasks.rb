class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :task_name, :null => false
      t.text :description

      t.timestamps
    end
  end
end
