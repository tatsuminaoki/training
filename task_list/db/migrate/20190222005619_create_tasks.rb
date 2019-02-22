class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.text :name
      t.text :content
      t.integer :priority
      t.integer :status
      t.datetime :endtime

      t.timestamps
    end
  end
end
