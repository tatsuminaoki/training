# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false, default: 1, limit: 1, unsigned: true

      t.timestamps
    end
  end
end
