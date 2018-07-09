class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name, :null => false
      t.string :mail_address, :null => false
      t.string :password_digest, :null => false
      t.integer :admin, :unsigned => true, :null => false, :default => 0, :limit => 1

      t.timestamps
    end
  end
end
