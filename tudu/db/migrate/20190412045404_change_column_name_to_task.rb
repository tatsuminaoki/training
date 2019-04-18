class ChangeColumnNameToTask < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :name, :string, null: false, limit: 20
  end

  def down
    change_column :tasks, :name, :string, null: false, limit: 50
  end
end
