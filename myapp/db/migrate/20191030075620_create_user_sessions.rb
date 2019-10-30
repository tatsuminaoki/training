class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, foreign_key: true, null: false
      t.string :session

      t.timestamps
    end
  end
end
