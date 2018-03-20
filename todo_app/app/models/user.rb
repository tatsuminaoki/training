class User < ApplicationRecord
  has_many :tasks

  validates :name, presence: true, length: { maximum: 20 }
end
