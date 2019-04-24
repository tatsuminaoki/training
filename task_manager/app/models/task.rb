# frozen_string_literal: true

class Task < ApplicationRecord
  extend Enumerize
  enumerize :status, in: { new: 0, wip: 1, done: 2, pending: 3 }

  validates :name, presence: true, length: { maximum: 64 }
end
