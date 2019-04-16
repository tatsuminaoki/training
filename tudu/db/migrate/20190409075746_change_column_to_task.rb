class ChangeColumnToTask < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :name, :string, limit: 50, null: false
    change_column :tasks, :content, :text, null: false
  end

  def down
    change_column :tasks, :name, :string, limit: 50, null: true
    change_column :tasks, :content, :text, null: true
  end
end
