# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_one :login, dependent: :destroy
  validates :authority, presence: true, inclusion: { in: ValueObjects::Authority.get_list.keys }
end
