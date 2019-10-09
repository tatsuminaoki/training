# frozen_string_literal: true

class RenameLimitToTaskLimit < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :limit, :task_limit
  end
end
