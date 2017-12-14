class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :label_id, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validate :end_date_valid?

  enum status: { not_started: 0, underway: 1, done: 2 }
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }

  enum priority: { low: 0, middle: 1, high: 2 }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  before_validation :set_dummy_value

  def self.search(params)
    params[:order] ||= ''
    result = case
             when params[:order].include?('end_date')
               self.order(end_date: order_option(params[:order]))
             when params[:order].include?('priority')
               self.order(priority: order_option(params[:order]))
             else
               self.order(created_at: :desc)
             end

    result = result.where('status = ?', params[:status]) if params[:status].present?
    result = result.where('name = ?', params[:name]) if params[:name].present?
    result
  end

  private

  def end_date_valid?
    # ActiveRecordによって強制的にcastされる値('abc'など)はnilになるので
    # end_date_before_type_castが存在してend_dateがnullなら不正な値として除外する
    if end_date_before_type_cast.present? && end_date.nil?
      errors.add(:end_date, I18n.t('errors.messages.end_date.invalid'))
      return false
    end

    if date_valid?(end_date)
      return true
    else
      errors.add(:end_date, I18n.t('errors.messages.end_date.not_exist'))
      return false
    end
  end

  def date_valid?(date)
    return true if date.nil? || date.instance_of?(Date)
    !! Date.parse(date) rescue false
  end

  def self.order_option(str)
    str.include?('asc') ? :asc : :desc
  end

  def set_dummy_value
    #DB制約を実装した関係で値が必要なのでダミー値をセット　-> 今後の機能実装に合わせて解放する
    if Rails.env == "development"
      self.user_id = 0
    end
  end
end
