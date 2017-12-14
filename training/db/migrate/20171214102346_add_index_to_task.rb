class AddIndexToTask < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, :user_id
  end
end
