class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string    :status, null: false
      t.timestamps
    end
  end
end
