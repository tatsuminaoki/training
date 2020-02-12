class User < ApplicationRecord
  has_many :tasks
  has_one :login
  validates :authority, presence: true, inclusion: { in: ValueObjects::Authority.get_list.keys }
end
