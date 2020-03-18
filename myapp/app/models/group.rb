# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :project

  validates :name, presence: true
  validates :sort_number, presence: true, uniqueness: { scope: :project_id , message: I18n.t('validate.errors.groups.sort_number_and_project_id_unieueness') }

  DEFAULT_GROUP_NAMES = %w[Todo InProgress Review Done].freeze

  def self.create_default_groups(id)
    DEFAULT_GROUP_NAMES.each_with_index do |name, index|
      Group.new(name: name, sort_number: index, project_id: id).save
    end
  end
end
