# frozen_string_literal: true

class AddIndexTasks < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :priority
    add_index :tasks, :status
  end
end
