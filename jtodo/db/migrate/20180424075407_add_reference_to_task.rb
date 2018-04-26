class AddReferenceToTask < ActiveRecord::Migration[5.2]
  def up
    add_reference :tasks, :user, foreign_key: true
    change_column :tasks, :user_id, :bigint, after: :id
  end
  def down
    remove_reference :tasks, :user
  end
end
