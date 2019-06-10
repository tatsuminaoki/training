# frozen_string_literal: true

class CreateUserCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :user_credentials do |t|
      t.references 'user', null: false, index: true, unsigned: true
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
