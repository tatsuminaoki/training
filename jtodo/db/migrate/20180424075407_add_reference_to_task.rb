class AddReferenceToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :user, foreign_key: true
    change_column :tasks, :user_id, :bigint, after: :id
  end
end
