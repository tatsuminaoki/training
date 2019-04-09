class AddIndexToLabels < ActiveRecord::Migration[5.2]
  def change
    add_index :labels, :name, :length => 10
    change_column_null :labels, :name, false
  end
end