class AddReferenceToLabel < ActiveRecord::Migration[5.2]
  def change
    add_reference :labels, :task, foreign_key: true, after: :id
    add_reference :labels, :label_type, foreign_key: true, after: :id
  end
end
