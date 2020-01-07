class ChangeTitleToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :title, :string, { null: false, limit: 50 }
  end

  def down
    change_column :tasks, :title, :string, { null: true, limit: nil }
  end
end
