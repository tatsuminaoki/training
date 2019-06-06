class AddColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :finished_on, :date, null: false
  end
end
