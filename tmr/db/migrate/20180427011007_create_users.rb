class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login_id
      t.string :password_hash
      t.boolean :admin_flag

      t.timestamps
    end
  end
end
