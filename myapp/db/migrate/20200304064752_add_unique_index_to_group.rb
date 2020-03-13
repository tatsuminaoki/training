class AddUniqueIndexToGroup < ActiveRecord::Migration[6.0]
  def change
    add_index  :groups, [:sort_number, :project_id], unique: true
  end
end
