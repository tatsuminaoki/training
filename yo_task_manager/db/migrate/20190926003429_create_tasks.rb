# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, comments: '名前'
      t.text :body,    comments: '詳細'

      t.timestamps
    end
  end
end
