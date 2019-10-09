class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 32, null: false
      t.string :email, limit: 128, null: false
      t.string :encrypted_password, null: false
      t.integer :role, limit: 1, null: false

      t.timestamps
    end
  end
end