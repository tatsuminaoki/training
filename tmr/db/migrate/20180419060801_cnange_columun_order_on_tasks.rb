class CnangeColumunOrderOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :user_id, :integer, after: :id
  end
end
