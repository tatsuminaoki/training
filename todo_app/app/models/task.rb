# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, required: false

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validate :validate_datetime

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: %i[low normal high quickly right_now].freeze

  SORT_KINDS = %i[created_at deadline priority].freeze

  class << self
    def search(title: nil, status: nil, sort: 'created_at', page: 1)
      query = self
      query = query.where(title: title) if title.present?
      query = query.where(status: status) if status.present?
      query = query.order(sort_column(sort) => :desc, :id => :desc)
      query.page(page)
    end

    def sort_column(value)
      return :created_at if value.blank?
      SORT_KINDS.find { |column| column == value.to_sym } || :created_at
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
