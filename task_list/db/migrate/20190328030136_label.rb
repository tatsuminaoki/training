class Label < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.integer :name

      t.timestamps
    end
  end
end
