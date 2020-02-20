class AddIndexProjectsName < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, :name
  end
end
