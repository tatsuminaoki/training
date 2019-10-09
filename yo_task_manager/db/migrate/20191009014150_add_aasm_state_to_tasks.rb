class AddAasmStateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :aasm_state, :string, after: :task_limit
  end
end
