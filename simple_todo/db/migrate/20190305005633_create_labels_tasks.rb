class CreateLabelsTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :labels_tasks, id: false do |t|
      t.references :label, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false
    end
  end
end
