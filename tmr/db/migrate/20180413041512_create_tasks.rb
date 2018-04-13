class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :status
      t.integer :priority
      t.datetime :due_date
      t.datetime :start_date
      t.datetime :finkished_date

      t.timestamps
    end
  end
end
