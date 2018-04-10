class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.date :due_date, null: false
      t.integer :priority, null: false, limit: 1
      t.integer :status, default: 0, null: false, limit: 1
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
