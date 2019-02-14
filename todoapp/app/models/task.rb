class Task < ApplicationRecord
  validates :title,
            presence: true,
            length: { maximum: 64 }
  validates :status,
            presence: true
  validate :end_at_cannot_be_in_the_past, :status_out_of_range

  STATUS_NEW_TASK = 1
  STATUS_WORKING = 2
  STATUS_COMPLETED = 3
  enum status: {
    new_task: STATUS_NEW_TASK,
    working: STATUS_WORKING,
    completed: STATUS_COMPLETED
  }

  belongs_to :user

  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  scope :recent, -> { order(created_at: :desc) }

  private

  def end_at_cannot_be_in_the_past
    # 過去日付は入力できないよ
    if end_at.present? && end_at <= Date.yesterday
      errors.add(:end_at,
                 I18n.t('errors.messages.end_at_cannot_be_in_the_past'))
    end
  end

  def status_out_of_range
    # statusが保存できるのは、定義したキーだけだよ
    unless Task.statuses.keys.include?(status)
      errors.add(:status,
                 I18n.t('errors.messages.status_out_of_range'))
    end
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[recent]
  end
end
