class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, foreign_key: true, :after => :description
  end
end
