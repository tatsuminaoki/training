class CreateLabelTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :label_types do |t|
      t.string :label_name, :null => false

      t.timestamps
    end
  end
end
