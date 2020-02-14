class Task < ApplicationRecord
  enum status: { 'open': 1, 'inprogress': 2, 'review': 3, 'reopen': 4, 'done': 5 }
  enum priority: { 'highest': 1, 'higher': 2, 'middle': 3, 'lower': 4, 'lowest': 5 }

  validates :summary,
    presence: true,
    length: { maximum: 50 }

  validates :description,
    length: { maximum: 3000 }

  validates :priority,
    presence: true

  validates :status,
    presence: true

end
