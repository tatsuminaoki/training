class AddUserToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :user, foreign_key: true, after: :id
  end
end
