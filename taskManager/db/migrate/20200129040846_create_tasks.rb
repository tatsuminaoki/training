class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.text :summary, null: false
      t.text :discription
      t.datetime :due
      t.integer :priority, null: false, limit: 1, default: 3 
      t.integer :status, null: false, limit: 1, default: 0
      t.integer :label
      t.integer :drafter
      t.integer :reporter
      t.integer :assignee

      t.timestamps
    end
  end
end
