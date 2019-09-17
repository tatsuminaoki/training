class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.bigint :user_id, null: false
      t.string :name, null: false
      t.text :description, comment: 'タスク内容'
      t.integer :priority, null: false, comment: '1:低 2:中 3:高 '
      t.integer :status, null: false, comment: '1:未着手 2:着手 3:完了 '
      t.datetime :duedate, comment: '終了期限'
      t.timestamps
    end
    add_foreign_key :tasks, :users
  end
end
