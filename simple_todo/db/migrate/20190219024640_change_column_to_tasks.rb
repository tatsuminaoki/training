class ChangeColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :title, :string, limit: 40
    change_column :tasks, :description, :string, limit: 200
  end
end
