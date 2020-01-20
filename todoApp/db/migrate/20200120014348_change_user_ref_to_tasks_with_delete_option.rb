class ChangeUserRefToTasksWithDeleteOption < ActiveRecord::Migration[6.0]
  def change
    remove_reference :tasks, :user, null: false, foreign_key: true
    add_reference :tasks, :user, null: false, foreign_key: true, on_delete: :cascade
  end
end
