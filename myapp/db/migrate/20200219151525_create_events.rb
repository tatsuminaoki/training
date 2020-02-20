class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.integer :sort_number, null: false
      t.references :project, foreign_key: true, null: false
      t.timestamps
    end
  end
end
