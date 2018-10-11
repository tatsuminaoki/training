class User < ApplicationRecord
  has_many :task, dependent: :destroy
end
