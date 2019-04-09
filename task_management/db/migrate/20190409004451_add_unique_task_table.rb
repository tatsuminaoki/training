class AddUniqueTaskTable < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column :tasks, :task_name, :string, null: false, unique: true
    end

    def down
      change_column :tasks, :task_name, :string, null: true, unique: false
    end
  end
end
