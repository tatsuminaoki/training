class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.datetime :limit
      t.integer :priority
      t.integer :label_id
      t.integer :status

      t.timestamps
    end
  end
end
