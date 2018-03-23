class AddPasswordColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string, after: :name
  end
end
