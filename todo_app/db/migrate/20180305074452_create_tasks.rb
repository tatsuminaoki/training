class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, :limit => 50
      t.string :description
      t.date :deadline, null: false
      t.string :status, null: false, :limit => 10
      t.string :priority, null: false, :limit => 10
      t.timestamps
    end
  end
end
