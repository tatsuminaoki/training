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

  def set_label_names
    @label_names = labels.pluck(:name).join(',')
  end

  def update_labels
    new_labels = []
    label_names.split(',').each do |label_name|
      new_labels << Label.find_or_initialize_by(name: label_name)
    end
    (labels - new_labels).each do |disused_label|
      labels.delete(disused_label)
    end
    (new_labels - labels).each do |new_label|
      labels << new_label
    end
  end
end
