class RemoveUserIeFromTasks2 < ActiveRecord::Migration[5.2]
  def change
    remove_reference :tasks, :user, foreign_key: true
  end
end
