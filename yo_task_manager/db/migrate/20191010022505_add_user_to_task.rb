class AddUserToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, null: false, foreign_key: true, after: :id
  end
end
