class NotNullToLabel < ActiveRecord::Migration[5.2]
  def up
    change_column :labels, :label, :string, null: false
  end

  def down
    change_column :labels, :label, :string, null: true
  end
end
