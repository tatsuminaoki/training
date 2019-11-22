# frozen_string_literal: true

class ChangeTitleAndStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :status, false
    change_column_default :tasks, :status, from: nil, to: 0
  end
end
