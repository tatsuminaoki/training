class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all

  has_secure_password

  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }

  SORT_KINDS = %i[created_at name].freeze

  class << self
    def search_by_id(user_id, sort: 'name', page: 1)
      where(id: user_id)
        .order_by(sort: sort)
        .first
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
      order(sort_column(sort) => :desc, :id => :desc)
    end

    def sort_column(value)
      SORT_KINDS.find { |column| column == value.to_sym } || :name
    end
  end

  private_class_method :sort_column
end
