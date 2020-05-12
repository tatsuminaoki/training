class CreateStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.string  :name, null: false, unique: true
      t.integer :rate, null: false, unique: true

      t.timestamps
    end
  end
end
