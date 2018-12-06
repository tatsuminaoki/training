class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login_id
      t.string :name
      t.string :password
      t.integer :auth_level
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
