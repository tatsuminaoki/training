class ChangeColumnNullToTasks < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column_default :tasks, :user_id, default: ''
      change_column_null :tasks, :user_id, false
      change_column_null :tasks, :name, false
    end
    def down
      change_column_default :tasks, :user_id, default: nil
      change_column_null :tasks, :user_id, true
      change_column_null :tasks, :name, true
    end
  end
end
