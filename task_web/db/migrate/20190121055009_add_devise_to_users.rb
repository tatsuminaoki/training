# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[5.2]
  def up
    change_table :users do |t|
      ## Database authenticatable for devise
      t.string :email,              null: false, default: "", after: :name
      t.string :encrypted_password, null: false, default: "", after: :email
    end
    add_index :users, :email,                unique: true
  end
  def down
    remove_index :users, :email
    remove_column :users, :email
    remove_column :users, :encrypted_password
  end
end
