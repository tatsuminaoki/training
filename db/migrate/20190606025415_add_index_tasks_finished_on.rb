class AddIndexTasksFinishedOn < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :finished_on
  end
end
