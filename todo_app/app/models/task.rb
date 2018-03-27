# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :user_id, presence: true, numericality: true
  validate :validate_datetime

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: %i[low normal high quickly right_now].freeze

  SORT_KINDS_DESC = %i[created_at priority].freeze
  SORT_KINDS_ASC = %i[deadline].freeze
  SORT_KINDS = (SORT_KINDS_DESC | SORT_KINDS_ASC).freeze

  class << self
    def search(user_id: nil, title: nil, status: nil, sort: 'created_at', page: 1)
      query = self
      query = query.where(user_id: user_id) if user_id.present?
      query = query.where(title: title) if title.present?
      query = query.where(status: status) if (Task.statuses.keys & [status]).present?
      query = query.order(sort_column(sort) => sort_order(sort), :id => :desc)
      query.page(page)
    end

    def task_count_group_by(user_id)
      where(user_id: user_id).group(:status).count
    end

    def sort_column(value)
      return :created_at if value.blank?
      SORT_KINDS.find { |column| column == value.to_sym } || :created_at
    end

    def sort_order(value)
      column = sort_column(value)
      return :desc if SORT_KINDS_DESC.include?(column.to_sym)
      return :asc if SORT_KINDS_ASC.include?(column.to_sym)
    end
  end

  private

  def validate_datetime
    errors.add(:deadline, I18n.t('errors.messages.invalid_datetime')) unless valid_datetime?
  end

  def valid_datetime?
    DateTime.parse(deadline.to_s).getlocal.present?
  rescue
    false
  end
end
