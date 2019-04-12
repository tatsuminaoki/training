class Task < ApplicationRecord
  validates :name,
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 20, message: I18n.translate("validates.length") }
  validates :content,
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 500, message: I18n.translate("validates.length") }
  validate :expire_date_is_valid?

  STATUS_NOT_YET = 0
  STATUS_DOING = 1
  STATUS_DONE = 2

  STATUS = {
    STATUS_NOT_YET => '未着手',
    STATUS_DOING => '着手中',
    STATUS_DONE => '完了'
  }.freeze

  def self.search(search_params)
    task = self
    task = task.where(status: search_params[:status]) if search_params[:status].present?
    task = task.where(['name LIKE ?', "%#{search_params[:q]}%"]) if search_params[:q].present?

    task
  end

  private
    def expire_date_is_valid?
      begin
        Date.parse self.expire_date.to_s if self.expire_date.present?
      rescue ArgumentError
        # 言語ファイルの %{attribute} がうまく変換されないため、外から渡す
        errors.add(
          :expire_date,
          I18n.translate(
            "validates.date",
            { attribute: I18n.translate("activerecord.attributes.task.expire_date") }
          )
        )
      end
    end
end
