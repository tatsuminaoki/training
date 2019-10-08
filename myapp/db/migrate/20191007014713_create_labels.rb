class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 16, null: false

      t.timestamps
    end
  end
end
