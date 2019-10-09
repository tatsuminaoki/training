class AddIndexTasksTitleAasmState < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, [:title, :aasm_state]
  end
end
