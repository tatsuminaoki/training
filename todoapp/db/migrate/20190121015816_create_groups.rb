class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, limit: 64

      t.timestamps null: false
    end
  end
end
