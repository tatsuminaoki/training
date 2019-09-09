class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, :null => false, :unsigned => true
      t.boolean :status, :null => false, :default => false
      t.string :title, :null => false
      t.text :description

      t.timestamps
    end
  end
end
