class Task < ApplicationRecord
  belongs_to :status 

  validates :task_name,
    uniqueness: { message: I18n.t("validates.unique") },
    presence: { message: I18n.t("validates.presence") },
    length: { maximum: 255, too_long: I18n.t("validates.length") }
  validates :contents,
    presence: { message: I18n.t("validates.presence") },
    length: { maximum: 255, too_long: I18n.t("validates.length") }
end
