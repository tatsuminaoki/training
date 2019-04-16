class Task < ApplicationRecord
  validates :name,
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 50, message: I18n.translate("validates.length") }
  validates :content,
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 500, message: I18n.translate("validates.length") }
  validate :expire_date_is_valid?

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
