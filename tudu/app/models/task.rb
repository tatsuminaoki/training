class Task < ApplicationRecord
  validates :name, 
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 50, message: I18n.translate("validates.length") }
  validates :content, 
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 500, message: I18n.translate("validates.length") }
end
