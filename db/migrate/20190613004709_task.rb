class Task < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :title, :string, limit: 255
    change_column :tasks, :detail, :string, limit: 255, null: false
  end
end
