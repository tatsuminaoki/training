class Group < ApplicationRecord
  belongs_to :project

  validates :name, presence: true

  CREATE_DEFAULT_GROUP_NAMES = %w(Todo InProgress Review Done)

  def self.create_default_groups(id)
    CREATE_DEFAULT_GROUP_NAMES.each_with_index do |name, index|
      Group.new(name: name, sort_number: index, project_id: id).save
    end
  end
end
