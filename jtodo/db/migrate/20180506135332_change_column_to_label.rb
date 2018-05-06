class ChangeColumnToLabel < ActiveRecord::Migration[5.2]
  def change
    change_column :labels, :user_id, :bigint, after: :id
  end
end
