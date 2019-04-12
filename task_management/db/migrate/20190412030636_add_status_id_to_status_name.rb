class AddStatusIdToStatusName < ActiveRecord::Migration[5.2]
  def change
    change_column :statuses, :id, :integer, limit: 1
    add_foreign_key :tasks, :statuses, column: "status_id"
  end
end
