class AddIndexToLabels < ActiveRecord::Migration[5.2]
  def change
    change_column :labels, :name, :string, limit: 10
    change_column_null :labels, :name, false
  end
end
