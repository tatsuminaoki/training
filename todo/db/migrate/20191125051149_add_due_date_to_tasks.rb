# frozen_string_literal: true

class AddDueDateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :due_date, :datetime, after: :status
  end
end
