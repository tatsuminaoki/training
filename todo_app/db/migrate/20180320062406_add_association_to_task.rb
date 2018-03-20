class AddAssociationToTask < ActiveRecord::Migration[5.1]
  def change
    add_reference :tasks, :user, index: true, after: :priority
  end
end
