class AddRestrictionToTasks < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :user_id, :integer, null: false
    change_column :tasks, :status, :integer, null: false
    change_column :tasks, :priority, :integer, null: false
    change_column :tasks, :title, :string, null: false
    change_column :tasks, :description, :text, null: false
  end

  def down
    change_column :tasks, :user_id, :integer, null: true, default: nil
    change_column :tasks, :status, :integer, null: true, default: nil
    change_column :tasks, :priority, :integer, null: true, default: nil
    change_column :tasks, :title, :string, null: true, default: nil
    change_column :tasks, :description, :string, null: true, default: nil
  end
end
