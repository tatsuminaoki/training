class Task < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :labels

  enum status: %i[yet doing done]

  validates :title ,:user_id, :limit, :status, presence: { message: I18n.t('messages.required') }
  validates :title, length: { maximum: 40, too_long: I18n.t('messages.too_long') }
  validates :description, length: { maximum: 200, too_long: I18n.t('messages.too_long') }
  validate :limit_date_validate

  def self.user_search(user_id)
    Task.where(user_id: user_id)
  end

  def self.title_search(title)
    Task.where(['title Like ?',"%#{title}%"])
  end

  def self.status_search(status)
    Task.where(status: status)
  end

  def self.label_search(label_id)
    task_ids = Label.joins(:labels_tasks).where('labels_tasks.label_id in (?)', label_id).pluck(:task_id)
    Task.where(id: task_ids)
  end

  def limit_date_validate
    if limit < Time.zone.now.to_datetime
      errors.add(:limit , I18n.t('messages.timeover'))
    end
  end
end
