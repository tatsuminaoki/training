class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validate :validate_datetime

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: Hash[%i[low normal high quickly right_now].map { |sym| [sym, sym.to_s] }].freeze

  private

  def validate_datetime
    errors.add(:deadline, I18n.t('errors.messages.invalid_datetime')) unless valid_datetime?
  end

  def valid_datetime?
    DateTime.parse(deadline.to_s).present? rescue false
  end

  def self.search(params)
    sort = params[:sort].present? && valid_column_name?(params[:sort]) ? params[:sort] : :created_at
    all.order(sort.to_sym).order(:id).reverse_order
  end

  private

  def self.valid_column_name?(column_name)
    Task.columns.map { |col| col.name.to_sym }.include?(column_name.to_sym)
  end
end
