class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, null: true
      t.string :color, null: false, default: '#B4BAC4'
      t.references :project, foreign_key: true, null: false
      t.timestamps
    end
  end
end
