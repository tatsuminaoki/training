class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.references :user, :null => false, foreign_key: true
      t.string :name, :null => false, :limit => 64

      t.timestamps null:false
    end
  end
end
