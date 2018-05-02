class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, :dependent => :destroy
  has_many :labels, through: :task_labels
  accepts_nested_attributes_for :task_labels, allow_destroy: true

  attr_accessor :label_names

  enum status: [:waiting, :working, :done]
  enum priority: [:low, :middle, :high]
  validates :title,     presence: true, length: { maximum: 255 }
  validates :status,    inclusion: { in: Task.statuses.keys }
  validates :priority,  inclusion: { in: Task.priorities.keys }

  def self.search(search)
    if search
      where('title LIKE :search OR description LIKE :search', search: "%#{search}%")
    else
      self
    end
  end

  def self.sortable
    ['priority','due_date']
  end
end
