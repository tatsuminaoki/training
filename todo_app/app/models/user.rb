class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all

  has_secure_password

  before_destroy :administrator_must_be_exist_at_least_one

  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :role, presence: true
  validate :administrator_must_be_exist_at_least_one, if: proc { |user| user.role == User.roles.keys[0] }, on: :update
  validates :password, presence: true, length: { minimum: 6 }, if: proc { |user| user.password.present? }, on: :update

  enum role: %i[general administrator].freeze

  SORT_KINDS = %i[created_at name].freeze

  class << self
    def search_by_id(user_id, sort: 'name')
      order_by(sort: sort)
        .find(user_id)
    end

    def search_all(sort: 'name', page: 1)
      order_by(sort: sort)
        .page(page)
    end

    def search_by_name(name)
      where(name: name)
    end

    def order_by(sort: 'name')
      sort ||= :name
      order(sort_column(sort) => :asc, :id => :desc)
    end

    def sort_column(value)
      SORT_KINDS.find { |column| column == value.to_sym } || :name
    end
  end

  private_class_method :sort_column

  private

  def administrator_must_be_exist_at_least_one
    return true if User.where(role: User.roles[:administrator]).where.not(id: id).count.positive?

    errors.add(:base, I18n.t('errors.messages.at_least_one_administrator'))
    throw :abort
  end
end
