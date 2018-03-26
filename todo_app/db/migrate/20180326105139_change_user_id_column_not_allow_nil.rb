class ChangeUserIdColumnNotAllowNil < ActiveRecord::Migration[5.1]
  def up
    # デフォルトでadministratorに紐付ける
    if Task.count > 1
      user = User.find_by(name: 'administrator')
      user ||= User.create(name: 'administrator', password: 'foobar', password_confirmation: 'foobar')
      Task.where(user_id: nil).update_all(user_id: user.id)
    end

    change_column :tasks, :user_id, :bigint, null: false
  end

  def down
    # 無理に外部キーを外してnullにしない
    change_column :tasks, :user_id, :bigint, null: true
  end
end
