# frozen_string_literal: true

class ChangeColumnOnTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :body, false
  end
end
