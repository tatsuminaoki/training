class Task < ApplicationRecord
  enum status: { '未着手': 0, '着手中': 1, '完了': 2}

  validates :title ,:user_id, :limit, :status, presence: { message: I18n.t('messages.required') }
  validates :title, length: { maximum: 40, too_long: I18n.t('messages.too_long') }
  validates :description, length: { maximum: 200, too_long: I18n.t('messages.too_long') }
  validate :limit_date_validate

  def self.title_search(title)
    Task.where(['title Like ?',"%#{title}%"])
  end

  def self.status_search(status)
    Task.where(status: status)
  end

  def limit_date_validate
    if limit < Time.zone.now.to_datetime
      errors.add(:limit , I18n.t('messages.timeover'))
    end
  end
end
