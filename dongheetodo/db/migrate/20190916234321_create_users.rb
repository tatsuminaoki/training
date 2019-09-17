class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users, id: false do |t|
      t.string :id, null: false, comment: 'ユーザID'
      t.string :password_digest, null: false, comment: '暗号化されたパスワード'
      t.string :email, null: false, comment: 'メールアドレス'
      t.timestamps
    end
    execute 'ALTER TABLE users ADD PRIMARY KEY(id);'
  end
  def down
    drop_table :users
  end
end
