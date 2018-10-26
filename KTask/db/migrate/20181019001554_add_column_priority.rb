class AddColumnPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :integer, before: :end_time, null: false
  end
end
