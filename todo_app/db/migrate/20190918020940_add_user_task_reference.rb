class AddUserTaskReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :user, index: true, first: true

    # ここまでに作成したタスクはseedで作成したユーザーに紐付けておく
    reversible do |dir|
      dir.up do
        execute('UPDATE `tasks` SET `user_id` = (SELECT `id` FROM `users` ORDER BY `id` LIMIT 1)')
      end

      dir.down do
      end
    end
  end
end
