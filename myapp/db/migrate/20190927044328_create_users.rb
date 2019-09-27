class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :login_id, null: false
      t.string :password, null: false

      t.timestamps
    end

    add_index :users, :login_id, :unique => true
  end
end
