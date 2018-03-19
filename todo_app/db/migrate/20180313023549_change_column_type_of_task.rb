class ChangeColumnTypeOfTask < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
          UPDATE tasks SET priority= 
            CASE
            WHEN priority = 'low' THEN '0'
            WHEN priority = 'normal' THEN '1'
            WHEN priority = 'high' THEN '2'
            WHEN priority = 'quickly' THEN '3'
            WHEN priority = 'right_now' THEN '4'
            END;
    SQL

    change_column :tasks, :priority, :tinyint
  end

  def down
    change_column :tasks, :priority, :string, :limit => 10

    execute <<-SQL
          UPDATE tasks SET priority= 
            CASE
            WHEN priority = '0' THEN 'low'
            WHEN priority = '1' THEN 'normal'
            WHEN priority = '2' THEN 'high'
            WHEN priority = '3' THEN 'quickly'
            WHEN priority = '4' THEN 'right_now'
            END;
    SQL
  end
end
