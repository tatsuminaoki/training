# frozen_string_literal: true

class Project < ApplicationRecord
  paginates_per 11

  has_many :groups, dependent: :destroy

  validates :name, presence: true

  def create!
    Project.transaction do
      Group.transaction do
        self.save
        Group.create_default_groups(id)
      end
    end
  end
end
