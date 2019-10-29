class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :priority
      t.datetime :deadline
      t.integer :status
      t.string :name
      t.text :description
      t.bigint :user_id

      t.timestamps
    end
  end
end
