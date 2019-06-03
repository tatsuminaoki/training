# frozen_string_literal: true

class ChangeColumnToTask < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :name, :string, limit: 20
  end
end
