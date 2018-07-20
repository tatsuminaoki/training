class AddUniqueToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :mail_address, :unique => true
  end
end
