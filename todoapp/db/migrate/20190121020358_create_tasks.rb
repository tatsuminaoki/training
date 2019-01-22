class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, index: true, limit: 64
      t.text :description, null: true
      t.unsigned_integer :status, null: false, index: true, limit: 1
      t.datetime :end_at, null: true

      t.timestamps null: false
    end
  end
end
