class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :priority, null: false
      t.datetime :end_period_at, null: true
      t.string :creator_name, null: true
      t.string :assignee_name, null: true
      t.text :description, null: true
      t.timestamps
      t.references :event, foreign_key: true, null: false
      t.references :label, foreign_key: true
    end
  end
end
