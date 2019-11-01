class ChangeColumnToTask < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :name, :string, null: false
    change_column :tasks, :priority, :integer, null: false
    change_column :tasks, :status, :integer, null: false
    change_column :tasks, :due, :string, null: false
  end
end
