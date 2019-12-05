# frozen_string_literal: true

class AddUserRefToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, foreign_key: true
  end
end
