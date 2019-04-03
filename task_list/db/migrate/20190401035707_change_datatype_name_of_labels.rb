class ChangeDatatypeNameOfLabels < ActiveRecord::Migration[5.2]
  def change
    change_column :labels, :name, :string
  end
end