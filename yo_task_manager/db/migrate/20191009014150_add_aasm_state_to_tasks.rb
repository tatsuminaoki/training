class AddAasmStateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :aasm_state, :string
  end
end
