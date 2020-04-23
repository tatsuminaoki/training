class ChangeNotnullToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column_null :tasks, :title, false
  end

  def down
    change_column_null :tasks, :title, true
  end
end
