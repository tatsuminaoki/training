class Group < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :project

  validates :name, presence: true

  DEFAULT_GROUP_NAMES = %w(Todo InProgress Review Done)

  def self.create_default_groups(id)
    DEFAULT_GROUP_NAMES.each_with_index do |name, index|
      Group.new(name: name, sort_number: index, project_id: id).save
    end
  end
end
