class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :user_id, null: false
      t.string :name, null: false, comment: 'タスク名'
      t.text :description, comment: 'タスク内容'
      t.integer :priority, null: false, comment: '優先順位'
      t.integer :status, null: false, comment: 'ステータス'
      t.datetime :duedate, comment: '終了期限'
      t.timestamps
    end
    add_foreign_key :tasks, :users
  end
end
