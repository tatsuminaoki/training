class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :description, limit: 512
      t.references :user, foreign_key: true, null: false
      t.integer :priority, limit: 1, null: false
      t.integer :status, limit: 1, null: false
      t.date :due_date

      t.timestamps
    end
    add_index :tasks, :due_date
  end
end
