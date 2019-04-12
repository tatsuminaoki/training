class AddStatusAtToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :tinyint, after: :expire_date, null: false, default: 0
  end
end
