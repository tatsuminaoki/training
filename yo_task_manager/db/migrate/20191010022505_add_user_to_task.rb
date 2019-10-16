# frozen_string_literal: true

class AddUserToTask < ActiveRecord::Migration[6.0]
  def up
    add_reference :tasks, :user, foreign_key: true, after: :id
    if User.any?
      execute("update tasks set user_id = #{User.first.id};")
    else
      user = User.create!(login_id: 'dummy1', password: 'dummy1234', display_name: 'dummy1_name')
      execute("update tasks set user_id = #{user.id};")
    end
    change_column :tasks, :user_id, :bigint, null: false
  end

  def down
    remove_column :tasks, :user_id
  end
end
