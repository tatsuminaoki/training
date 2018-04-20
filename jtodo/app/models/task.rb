class Task < ApplicationRecord
  enum status: [:waiting, :working, :done]
  enum priority: [:low, :middle, :high]
  validates :title,     presence: true, length: { maximum: 255 }
  validates :status,    inclusion: { in: Task.statuses.keys }
  validates :priority,  inclusion: { in: Task.priorities.keys }

  def self.search(search)
    if search
      self.where('title LIKE :search OR description LIKE :search', search: "%#{search}%")
    else
      self
    end
  end
end
