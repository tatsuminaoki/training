class AddColumnTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :user_id, :unsigned_integer, null: false, after: :id
    add_column :tasks, :priority, :unsigned_tinyint, null: false, after: :description
    add_column :tasks, :status, :unsigned_tinyint, null: false, after: :priority
    add_column :tasks, :label_id, :unsigned_integer, after: :status
    add_column :tasks, :end_data, :date, after: :label_id
  end
end
