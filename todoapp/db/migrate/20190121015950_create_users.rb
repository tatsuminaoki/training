class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, limit: 64, index: { unique: true }
      t.string :encrypted_password, null: false
      t.string :name, null: false, limit: 64
      t.references :group, null: true, foreign_key: true
      t.unsigned_integer :role, null: false, limit: 1

      t.timestamps null: false
    end
  end
end
