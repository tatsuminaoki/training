class ChangeColumnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :detail, :text
  end
end
