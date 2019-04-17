class AddExpireAtToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :expire_date, :date, after: :content
  end
end
