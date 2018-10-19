class AddColumnPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :string, before: :end_time, null: false, limit: 30
  end
end
