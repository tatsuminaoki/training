class AddIndexToTask < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, :title
    add_index :tasks, :status
  end
end
