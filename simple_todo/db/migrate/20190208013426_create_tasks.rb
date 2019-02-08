class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :user_id, null: false
      t.datetime :limit, null: false
      t.integer :priority, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
