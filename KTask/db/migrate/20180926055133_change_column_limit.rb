class ChangeColumnLimit < ActiveRecord::Migration[5.2]
  def change
    change_column:tasks, :title, :string, null: false, limit: 20
    change_column:tasks, :content, :string, null: false
    change_column:tasks, :status, :integer, null: false
    change_column:tasks, :end_time, :datetime, null: false
  end
end
