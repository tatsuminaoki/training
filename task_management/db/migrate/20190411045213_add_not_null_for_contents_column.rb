class AddNotNullForContentsColumn < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :contents, :string, null: false
  end

  def down
    change_column :tasks, :contents, :string, null: true
  end
end
