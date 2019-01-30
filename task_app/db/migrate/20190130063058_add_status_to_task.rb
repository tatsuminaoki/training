class AddStatusToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer, after: :priority, limit: 1, null: false
  end
end
