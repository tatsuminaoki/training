class AddLimitToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :limit, :datetime, after: :body, comment: '終了期限'
  end
end
