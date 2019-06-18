# frozen_string_literal: true

class AddUserRefToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :user, index: true, unsigned: true
  end
end
