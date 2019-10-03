class AddIndexTasksName < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :name, length: 10
  end
end
