class CreateLabels < ActiveRecord::Migration[5.2]
  def up
    create_table :labels do |t|
      t.string :name

      t.timestamps
    end
  end
  def down
    drop_table :labels
  end
end
