class AddIndexUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :id
  end
end
