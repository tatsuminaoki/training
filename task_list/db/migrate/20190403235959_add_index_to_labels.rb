class AddIndexToLabels < ActiveRecord::Migration[5.2]
  def change
    change_column :labels, :name, :string, :length => 10
    change_column :labels, :name, :string, null: false
  end
end