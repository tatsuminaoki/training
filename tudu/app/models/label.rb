class Label < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks

  validates :name,
    presence: { message: I18n.translate("validates.presence") },
    length: { maximum: 20, message: I18n.translate("validates.length") }

  validates_uniqueness_of :name,
    scope: [:user_id],
    message: I18n.translate("validates.unique")
end
