class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string :mail, :null => false
      t.string :password, :null => false
      t.string :name, :null => false
      t.string :name_kana
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def down
      drop_table :users
  end
end
