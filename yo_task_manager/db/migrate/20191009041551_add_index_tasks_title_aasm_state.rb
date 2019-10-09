# frozen_string_literal: true

class AddIndexTasksTitleAasmState < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, %i[title aasm_state]
  end
end
