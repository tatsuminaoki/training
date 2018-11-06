class User < ApplicationRecord
  has_many :task, dependent: :destroy

  validates :mail,
            presence: true,
            uniqueness: { case_sensitive: false },
            email_format: {},
            length: { maximum: 255 }

  validates :user_name,
            presence: true,
            format: { with: /\A[\wa-zA-Z0-9ぁ-んァ-ン一-龥]+[\s　]?[\wa-zA-Z0-9ぁ-んァ-ン一-龥]+\z/ },
            length: { maximum: 255 }

  has_secure_password
end
