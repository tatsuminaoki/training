class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validate :validate_datetime

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: Hash[%i[low normal high quickly right_now].map { |sym| [sym, sym.to_s] }].freeze

  SORT_KIND = %i(created_at deadline).freeze

  class << self
    def search(sort: 'created_at')
      order(sort_column(sort) => :desc, :id => :desc)
    end

    def sort_column(value)
      return :created_at unless value.present?
      SORT_KIND.find { |column| column == value.to_sym } || :created_at
    end
  end

  private

  def validate_datetime
    errors.add(:deadline, I18n.t('errors.messages.invalid_datetime')) unless valid_datetime?
  end

  def valid_datetime?
    DateTime.parse(deadline.to_s).present? rescue false
  end

  # def self.search(params)
  #   query = self
  #   query = query.where(title: params[:title]) if params[:title].present?
  #   query = query.where(status: params[:status]) if params[:status].present?
  #
  #   sort = params[:sort].present? && valid_column_name?(params[:sort]) ? params[:sort] : :created_at
  #   query = query.all.order(sort.to_sym).order(:id).reverse_order
  #
  #   query
  # end
end
