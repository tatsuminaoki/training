# frozen_string_literal: true

class Project < ApplicationRecord
  paginates_per 11

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :groups, dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :name, presence: true

  def create!
    Project.transaction do
      self.save
      Group.transaction do
        Group.create_default_groups(id)
      end
      Label.transaction do
        Label.create_default_label(id)
      end
    end
  end
end
