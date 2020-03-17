class Project < ApplicationRecord
  paginates_per 11

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :groups, dependent: :destroy

  validates :name, presence: true

  def create!
    Project.transaction do
      Group.transaction do
        self.save!
        Group.create_default_groups(id)
      end
    end
  end
end
