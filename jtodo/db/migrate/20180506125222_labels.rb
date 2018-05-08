class Labels < ActiveRecord::Migration[5.2]
  def change
    add_reference :labels, :user, foreign_key: true
    remove_index :labels, :name
    add_index :labels, [:name, :user_id], unique: true
  end
end
