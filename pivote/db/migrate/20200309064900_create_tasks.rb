class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :priority, limit: 1, null: false
      t.integer :status, limit: 1, null: false
      t.datetime :deadline

      t.timestamps
    end
  end
end
