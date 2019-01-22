class CreateTaskLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :task_labels do |t|
      t.references :label_user, :null => false, foreign_key: { to_table: :users }
      t.references :label, :null => false, foreign_key: true 
      t.references :task, :null => false, foreign_key: true 
    end
  end
end
