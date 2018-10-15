class ChangeUserinfoLimit < ActiveRecord::Migration[5.2]
  def change
    change_column:users, :name, :string, limit: 30
    change_column:users, :email, :string, limit: 50
  end
end
