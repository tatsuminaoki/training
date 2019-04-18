class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :name, limit: 20, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_foreign_key :labels, :users, column: :user_id
  end
end
