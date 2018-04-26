class CreatePriorities < ActiveRecord::Migration[5.2]
  def change
    create_table :priorities do |t|
      t.string  :priority, null: false
      t.timestamps
    end
  end
end
