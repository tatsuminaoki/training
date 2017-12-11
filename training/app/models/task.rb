class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :priority, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :status, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :label_id, :numericality => { :greater_than_or_equal_to => 0, :allow_blank => true }
  validate :end_date_valid

  private

  def end_date_valid
    # ActiveRecordによって強制的にcastされる値('abc'など)は入力として正しく無いのでエラーにする
    unless end_date_before_type_cast.to_s == end_date.to_s
      errors.add(:end_date, I18n.t('errors.messages.end_date.invalid'))
      return false
    end

    return true if end_date.blank? || end_date.instance_of?(Date)
    unless date_valid?(end_date)
      errors.add(:end_date, I18n.t('errors.messages.end_date.not_exist'))
      return false
    end
  end

  def date_valid?(str)
    !! Date.parse(str) rescue false
  end
end
