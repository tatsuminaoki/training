class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.text :name, null: false
      t.text :content
      t.integer :priority, null: false
      t.integer :status, null: false
      t.datetime :endtime

      t.timestamps
    end
  end
end
