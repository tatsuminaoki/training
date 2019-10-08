# frozen_string_literal: true

class NotNullOnTitle < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :title, false
  end
end
