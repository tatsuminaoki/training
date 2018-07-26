class AddIndexToLabelType < ActiveRecord::Migration[5.2]
  def change
    add_index :label_types, :label_name, :unique => true
  end
end
