# frozen_string_literal: true

class CreateUserTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tokens do |t|
      t.references 'user', null: false, index: true, unsigned: true
      t.string :token, index: { unique: true }, null: false
      t.timestamp :expires_at, null: false

      t.timestamps
    end
  end
end
