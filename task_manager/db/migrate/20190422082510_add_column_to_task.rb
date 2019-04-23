class AddColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer, null: false, default: 0, index: true, after: :name
  end
end
